import 'dart:developer';

import 'package:delivary_partner/authentication/registration/domain/create_account.dart';
import 'package:delivary_partner/core/infra/secured_storage.dart';
import 'package:delivary_partner/core/network/api_endpoints.dart';
import 'package:delivary_partner/core/shared/dio_client_provider.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // ✅ only this, no legacy.dart

class PersonalDetailsNotifier extends Notifier<PersonalDetailsState> { // ✅
  @override
  PersonalDetailsState build() => const PersonalDetailsState();

  Future<void> submit({
  required String full_name,
  required String email,
  required String address,
  required String city,
  // ✅ removed: required File? profileImage,
}) async {
  // ... validation unchanged ...

  state = state.copyWith(isLoading: true, error: null);

  try {
    // ✅ clean JSON body — no profile_image
    final Map<String, dynamic> body = {
      'fullName': full_name.trim(),
      'email':     email.trim(),
      'address':   address.trim(),
      'city':      city,
    };
        final token = await SecureStorageService.getToken();
        log('personalDetails TOKEN: $token');
      // log('[$errorLabel] TOKEN: $token');

    log('personalDetails JSON body: $body');


    final response = await ref.read(dioClientProvider).post(
      APIEndpoints.personaldetails,
      data: body,
      options: Options(validateStatus: (s) => s != null && s < 500, headers: {'Authorization': 'Bearer $token'},),
    );

    log('personalDetails STATUS: ${response.statusCode}');
    log('personalDetails DATA  : ${response.data}');

    final ok = response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;

    if (ok) {
      state = state.copyWith(isLoading: false, isSuccess: true);
    } else {
      final data = response.data;
      final msg = data is Map
          ? data['message'] ?? 'Submission failed'
          : 'Submission failed';
      state = state.copyWith(isLoading: false, error: msg);
    }
  } on DioException catch (e) {
    log('personalDetails ERROR: ${e.type} | ${e.response?.data}');
    final data = e.response?.data;
    final msg = data is Map
        ? data['message'] ?? 'Network error. Try again.'
        : 'Network error. Try again.';
    state = state.copyWith(isLoading: false, error: msg);
  }
}}
// ✅ NotifierProvider, not StateNotifierProvider
final personalDetailsProvider =
    NotifierProvider<PersonalDetailsNotifier, PersonalDetailsState>(
  PersonalDetailsNotifier.new,
);