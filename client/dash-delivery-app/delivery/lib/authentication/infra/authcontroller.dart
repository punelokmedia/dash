import 'dart:developer';

import 'package:delivary_partner/authentication/shared/authprovider.dart';
import 'package:delivary_partner/core/infra/secured_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // ✅ no legacy.dart

enum AuthStatus {
  initial,
  otpSent,
  verified,
  loggedIn,
}

class AuthController extends Notifier<AsyncValue<AuthStatus>> { // ✅
  @override
  AsyncValue<AuthStatus> build() => const AsyncData(AuthStatus.initial);

  // ── Request OTP ───────────────────────────────────────────────────────────
  Future<void> requestOtp(String phone) async {
    state = const AsyncData(AuthStatus.initial);
    state = const AsyncLoading();
    try {
      await ref.read(authApiProvider).requestOtp(phone);
      state = const AsyncData(AuthStatus.otpSent);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // ── Verify OTP ────────────────────────────────────────────────────────────
  Future<void> verifyOtp(String phone, String otp) async {
    state = const AsyncData(AuthStatus.initial);
    state = const AsyncLoading();
    try {
      final data = await ref.read(authApiProvider).verifyOtp(phone, otp);

      log('verifyOtp FULL DATA: $data');

      if (data['success'] == true) {
        final token = (data['accessToken'] ??
                       data['token'] ??
                       data['authToken'] ??
                       data['access_token']) as String?;

        log('SAVED TOKEN: $token');

        if (token != null) {
          await SecureStorageService.saveToken(token);
        }
        state = const AsyncData(AuthStatus.verified);
      } else {
        state = AsyncError(
          Exception(data['message'] ?? 'Invalid OTP'),
          StackTrace.current,
        );
      }
    } catch (e, st) {
      log('verifyOtp CONTROLLER ERROR: $e');
      state = AsyncError(e, st);
    }
  }

  // ── Check auth status ─────────────────────────────────────────────────────
  Future<void> checkAuthStatus() async {
    final token = await SecureStorageService.getToken();
    if (token != null && token.isNotEmpty) {
      state = const AsyncData(AuthStatus.loggedIn);
    } else {
      state = const AsyncData(AuthStatus.initial);
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await SecureStorageService.deleteToken();
    state = const AsyncData(AuthStatus.initial);
  }
}

// ✅ NotifierProvider
