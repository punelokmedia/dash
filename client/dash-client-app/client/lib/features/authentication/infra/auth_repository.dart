import 'dart:developer';

import 'package:dash_logistics/core/errors/error_handler.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  // auth_repository.dart
  Future<String> sendOtp(String phone) async {
    try {
      final response = await dio.post(
        "api/auth/send-otp",
        data: {"mobile_number": phone},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        log("Otp sent successfully to $phone");
        log(response.toString());
        // Ensure you return the message so the controller can update the state
        return response.data['message'] ?? "OTP Sent Successfully";
      } else {
        throw response.data['message'] ?? "Server Error";
      }
    } on DioException catch (e) {
      log("Dio Error: ${e.response?.data}");
      throw e.response?.data['message'] ?? "Connection Error: ${e.message}";
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        "api/auth/verify-otp",
        data: {'mobile_number': phone, 'otp': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Return the message or token from API
        return response.data;
      } else {
        // This triggers the 'error' state in the controller
        throw response.data['message'] ?? "Invalid OTP. Please try again.";
      }
    } on DioException catch (e) {
      log("Dio Error: ${e.response?.data}");
      throw ErrorHandler.handle(e); // ← backend message flows to snackbar
    }
  }

  /// CHECK USER EXISTS
  Future<bool> checkUserExists(String phone) async {
    try {
      final cleanPhone = phone.replaceAll(RegExp(r'^\+91'), '');
      final response = await dio.post(
        "api/auth/check-user",
        data: {"mobile_number": cleanPhone},
      );

      if (response.statusCode == 200) {
        log(response.toString());
        return response.data['profileCompleted'] ?? false;
      } else {
        throw "Server error";
      }
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// CREATE ACCOUNT
  Future<Map<String, dynamic>> createAccount({
    required String fullName,
    required String email,
    required String usage,
    required String token,
  }) async {
    try {
      final response = await dio.post(
        "api/user/create-account",
        data: {
          "full_name": fullName,
          "email": email,
          "using_for": usage,
          // "mobile_number": phone,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.toString());
        return Map<String, dynamic>.from(response.data);
      } else {
        throw response.data["message"] ?? "Account creation failed";
      }
    } on DioException catch (e) {
      throw e.response?.data?["message"] ?? "Account creation failed";
    }
  }

  Future<void> logout(String token) async {
    try {
      await dio.post(
        'api/auth/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      log('LOGOUT ERROR => ${e.response?.data}');
      throw ErrorHandler.handle(e);
    }
  }
}
