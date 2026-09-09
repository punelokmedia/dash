import 'dart:async';
import 'dart:developer';
import 'package:dash_logistics/core/storage/storage_provider.dart';
import 'package:dash_logistics/features/authentication/domain/models/auth_state.dart';
import 'package:dash_logistics/features/authentication/shared/auth_provider.dart';
import 'package:dash_logistics/features/dashboard/address/infra/address_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthState> {
  FlutterSecureStorage get _storage => ref.read(secureStorageProvider);

  /// INITIAL AUTH STATE
  @override
  FutureOr<AuthState> build() async {
    final token = await _storage.read(key: 'token');

    if (token != null) {
      return AuthState(isLoggedIn: true, token: token);
    }

    return const AuthState();
  }

  /// SEND OTP
  Future<void> sendOtp(String phone) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      final message = await repo.sendOtp(phone);

      log("OTP SENT: $message");

      return AuthState(
        otpSent: true,
        isLoggedIn: false,
        message: message,
        phone: phone,
      );
    });
  }

  /// VERIFY OTP
  Future<void> verifyOtp({required String phone, required String otp}) async {
    state = const AsyncLoading();

    final repo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final rawResponse = await repo.verifyOtp(phone: phone, otp: otp);

      final Map<String, dynamic> response = Map<String, dynamic>.from(
        rawResponse,
      );

      log("VERIFY OTP RESPONSE: $response");

      final bool success = response["success"] == true;
      final String? token = response["access_token"]?.toString();
      final bool profileCompleted = await repo.checkUserExists(phone);
      final String? message = response["message"]?.toString();
      final String? userId = response["user"]?["id"]?.toString();

      if (!success || token == null) {
        throw message ?? "Invalid OTP";
      }

      /// SAVE TOKEN
      await _storage.write(key: "token", value: token);
      await _storage.write(key: "phone", value: phone);
      await _storage.write(key: "user_id", value: userId);

      return AuthState(
        otpSent: true,
        isLoggedIn: true,
        profileCompleted: profileCompleted,
        phone: phone,
        token: token,
        message: message ?? "OTP Verified",
      );
    });
  }

  /// CREATE ACCOUNT
  Future<void> createAccount({
    required String name,
    required String email,
    required String usage,
    // required String phone,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(authRepositoryProvider);

    /// get token saved after OTP verification
    final token = await _storage.read(key: "token");

    if (token == null) {
      throw "User session expired. Please login again.";
    }

    state = await AsyncValue.guard(() async {
      final response = await repo.createAccount(
        fullName: name,
        email: email,
        usage: usage,
        token: token,
        // phone: phone,
      );

      log("CREATE ACCOUNT RESPONSE: $response");

      // final token = response["access_token"];

      // if (token == null) {
      //   throw response["message"] ?? "Account creation failed";
      // }

      // await _storage.write(key: "token", value: token);

      return AuthState(
        isLoggedIn: true,
        token: token,
        message: "Account created successfully",
      );
    });
  }

  /// LOGOUT
  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      // ── Read token before deleting ─────────────────────────────────
      final token = await _storage.read(key: 'token');

      if (token != null) {
        final repo = ref.read(authRepositoryProvider);
        await repo.logout(token); // ← call API with token
      }

      // ── Clear all stored data ──────────────────────────────────────
      await _storage.delete(key: 'token');
      await _storage.delete(key: 'phone');
      await _storage.delete(key: 'user_id');

      ref.invalidate(addressControllerProvider);
      // ref.invalidate(ordersControllerProvider);
      // ref.invalidate(profileControllerProvider);
      // ref.invalidate(cartControllerProvider);

      state = const AsyncData(
        AuthState(isLoggedIn: false, otpSent: false, token: null),
      );
    } catch (e) {
      // ── Even if API fails, clear local storage and logout ──────────
      await _storage.delete(key: 'token');
      await _storage.delete(key: 'phone');
      await _storage.delete(key: 'user_id');

      state = const AsyncData(
        AuthState(isLoggedIn: false, otpSent: false, token: null),
      );
    }
  }


  /// RESET AUTH STATE
  void reset() {
    state = const AsyncData(AuthState());
  }
}
