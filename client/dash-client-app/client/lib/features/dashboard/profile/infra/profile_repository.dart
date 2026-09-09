import 'dart:developer';
import 'package:dash_logistics/core/errors/error_handler.dart';
import 'package:dash_logistics/features/dashboard/profile/domain/models/userProfile.dart';
import 'package:dio/dio.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> fetchProfile(String token);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final Dio _dio;

  ProfileRepositoryImpl(this._dio);

  @override
  Future<UserProfileModel> fetchProfile(String token) async {
    log(token);
    try {
      final response = await _dio.get(        // ✅ GET not POST
        '/api/user/basic-info',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      log('fetchProfile response: ${response.data}');

      // ✅ API returns { success: true, data: { full_name, email, profile_photo } }
      final data = response.data['data'] as Map<String, dynamic>;

      return UserProfileModel.fromJson(data);

    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}