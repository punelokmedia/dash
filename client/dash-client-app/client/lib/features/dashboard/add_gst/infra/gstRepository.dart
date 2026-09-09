// ignore_for_file: file_names

import 'dart:developer';
import 'package:dash_logistics/features/dashboard/add_gst/domain/models/gstIn_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class GstinRepository {
  Future<GstinModel> submitGstin(String gstin);
}

class GstinRepositoryImpl implements GstinRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  GstinRepositoryImpl(this._dio, this._storage);

  @override
  Future<GstinModel> submitGstin(String gstin) async {
    // Client-side format validation
    final gstinRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );

    if (!gstinRegex.hasMatch(gstin.toUpperCase())) {
      throw Exception(
        'Invalid GSTIN format. Please enter a valid 15-digit GSTIN.',
      );
    }

    try {
      // Read token saved after OTP verify
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('Session expired. Please log in again.');

      // POST /api/user/add-gstin
      final response = await _dio.post(
        '/api/user/add-gstin',
        data: {'gstin': gstin.toUpperCase()},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      log(response.toString());
      return GstinModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String? ??
          e.message ??
          'Something went wrong. Please try again.';
      throw Exception(message);
    }
  }
}