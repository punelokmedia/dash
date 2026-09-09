
import 'dart:developer';

import 'package:delivary_partner/core/network/api_endpoints.dart';
import 'package:delivary_partner/core/shared/dio_client_provider.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthApi {
  final Ref ref;

  AuthApi({required this.ref});
Future<void> requestOtp(String phone) async {
  try {
    final response = await ref.read(dioClientProvider).post(
      APIEndpoints.sendotp,
      data: {"mobile_number": phone},
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    log(' requestOtp STATUS: ${response.statusCode}');
    log(' requestOtp DATA  : ${response.data}');

    final statusOk = response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;

    if (!statusOk) {
      final msg = response.data?['message'] ?? 'Failed to send OTP';
      throw Exception(msg); // ← throws on 4xx so controller catches it
    }
  } on DioException catch (e) {
    log('requestOtp ERROR: ${e.type} | ${e.message}');
    rethrow; // ← bubbles up to controller
  }
}


Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
  try {
    final response = await ref.read(dioClientProvider).post(
      APIEndpoints.verifyotp,
      data: {"mobile_number": phone, "otp": otp},
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data)
        : <String, dynamic>{};

    final statusOk = response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;

    if (!statusOk) {
      throw Exception(responseData['message'] ?? 'Invalid OTP');
    }

    return {'success': true, ...responseData};
  } on DioException catch (e) {
    log(' verifyOtp ERROR: ${e.type} | ${e.message}');
    rethrow; // ← let controller handle it
  }
}

  // Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
  //   try {
  //     final response = await ref.read(dioClientProvider).post(
  //       APIEndpoints.verifyotp,         // ✅ FIXED: removed leading space ' ${...}'
  //       data: {"mobile_number": phone, "otp": otp},
  //       options: Options(
  //         validateStatus: (status) => status != null && status < 500,
  //       ),
  //     );

  //     log(response.toString());

  //     final statusOk = response.statusCode != null &&
  //         response.statusCode! >= 200 &&
  //         response.statusCode! < 300;

  //     final responseData = Map<String, dynamic>.from(response.data ?? {});
  //     final message = responseData['message']?.toString().toLowerCase() ?? '';

  //     final messageOk = message.contains('success') ||
  //         message.contains('verified') ||
  //         message.contains('login');

  //     final isSuccess = statusOk && messageOk;

  //     return {
  //       'success': isSuccess,
  //       'message': isSuccess
  //           ? 'OTP verified'
  //           : (responseData['message'] ?? 'Invalid OTP'),
  //       ...responseData,
  //     };
  //   } on DioException catch (e) {
  //     return {
  //       'success': false,
  //       'message': e.response?.data?['message'] ?? 'Network error. Please try again.',
  //     };
  //   }
  // }
}

