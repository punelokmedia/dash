import 'dart:developer';
import 'dart:io';

import 'package:delivary_partner/authentication/registration/domain/create_account.dart';
import 'package:delivary_partner/core/infra/secured_storage.dart';
import 'package:delivary_partner/core/network/api_endpoints.dart';
import 'package:delivary_partner/core/shared/dio_client_provider.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class CreateAccountNotifier extends StateNotifier<CreateAccountState> {
  final Ref ref;
  CreateAccountNotifier(this.ref) : super(const CreateAccountState());

  // ── Shared upload helper ───────────────────────────────────────────
  Future<bool> _upload({
    required String endpoint,
    required FormData formData,
    required String errorLabel,
  }) async {
    try {
      // ✅ await the token
      final token = await SecureStorageService.getToken();
      log('[$errorLabel] TOKEN: $token');

      if (token == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Session expired. Please login again.',
        );
        return false;
      }

      final dio = ref.read(dioClientProvider);
      final response = await dio.post(
        endpoint,
        data: formData,
        options: Options(
          validateStatus: (s) => s != null && s < 500,
          // ✅ manually attach token in case interceptor misses it
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      log('[$errorLabel] STATUS: ${response.statusCode}');
      log('[$errorLabel] RESPONSE: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      final message = response.data is Map
          ? (response.data['message'] ??
              response.data['error'] ??
              '$errorLabel upload failed')
          : '$errorLabel upload failed';

      state = state.copyWith(isLoading: false, error: message.toString());
      return false;
    } on DioException catch (e) {
      log('[$errorLabel] DioException: ${e.type} | ${e.message}');
      log('[$errorLabel] Response: ${e.response?.data}');

      final message = e.response?.data is Map
          ? (e.response?.data['message'] ??
              e.response?.data['error'] ??
              '$errorLabel upload failed. Please try again.')
          : '$errorLabel upload failed. Please try again.';

      state = state.copyWith(isLoading: false, error: message.toString());
      return false;
    } catch (e) {
      log('[$errorLabel] Unknown error: $e');
      state = state.copyWith(
        isLoading: false,
        error: '$errorLabel upload failed. Please try again.',
      );
      return false;
    }
  }

  // ── Upload Profile Image ───────────────────────────────────────────
  Future<void> uploadProfileImage({required File? profileImage}) async {
    if (profileImage == null) {
      state = state.copyWith(error: 'Please select a profile image');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);

    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(profileImage.path),
    });

    final success = await _upload(
      endpoint: APIEndpoints.profile,
      formData: formData,
      errorLabel: 'Profile Image',
    );
    if (success) state = state.copyWith(isLoading: false, isProfileImageUploaded: true);
  }

  // ── Upload Aadhaar Card ────────────────────────────────────────────
   Future<void> uploadAadhaar({required File? aadhaar}) async {
    if (aadhaar == null) {
      state = state.copyWith(error: 'Please upload your Aadhaar card');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(aadhaar.path), // ✅ was 'aadhaar_card'
    });

    final success = await _upload(
      endpoint: APIEndpoints.uploadadhar, // '/api/partner/upload-aadhaar-image'
      formData: formData,
      errorLabel: 'Aadhaar',
    );
    if (success) state = state.copyWith(isLoading: false, isAadhaarUploaded: true);
  }

  // ── Upload PAN Card ────────────────────────────────────────────────
  Future<void> uploadPan({required File? pan}) async {
    if (pan == null) {
      state = state.copyWith(error: 'Please upload your PAN card');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(pan.path),
    });

    final success = await _upload(
      endpoint: APIEndpoints.uploadpan,
      formData: formData,
      errorLabel: 'PAN',
    );
    if (success) state = state.copyWith(isLoading: false, isPanUploaded: true);
  }

  // ── Upload Driving License ─────────────────────────────────────────
  Future<void> uploadLicense({required File? license}) async {
    if (license == null) {
      state = state.copyWith(error: 'Please upload your Driving License');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(license.path),
    });

    final success = await _upload(
      endpoint: APIEndpoints.uploadlicense,
      formData: formData,
      errorLabel: 'License',
    );
    if (success) state = state.copyWith(isLoading: false, isLicenseUploaded: true);
  }

  // ── All documents uploaded gate ────────────────────────────────────
  bool get allDocumentsUploaded =>
      state.isAadhaarUploaded &&
      state.isPanUploaded &&
      state.isLicenseUploaded;
}

