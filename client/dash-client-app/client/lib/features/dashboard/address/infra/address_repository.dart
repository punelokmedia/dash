import 'dart:developer';

import 'package:dash_logistics/core/errors/error_handler.dart';
import 'package:dash_logistics/features/dashboard/address/domain/address_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddressRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AddressRepository(this._dio, this._storage);

  Future<Options> _authOptions() async {
    final token = await _storage.read(key: 'token') ?? '';
    log('[AddressRepo] token: $token');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<List<AddressModel>> getAddresses() async {
    try {
      final options = await _authOptions();
      final response = await _dio.get('/addresses', options: options);

      final body = response.data as Map<String, dynamic>;
      if (body['success'] == true) {
        final data = body['data'] as List<dynamic>;
        log(data.toString());
        return data
            .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to fetch addresses');
    }  on DioException catch (e) {
      log('GET ADDRESSES ERROR => ${e.response?.data}');
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      final options = await _authOptions();
      final response = await _dio.delete('/addresses/$id', options: options);

      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw Exception('Failed to delete address');
      }
      
    } on DioException catch (e) {
      log('DELETE ADDRESS ERROR => ${e.response?.data}');
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> editAddress({
    required String id,
    required String name,
    required String phone,
    required String house,
    required String pincode,
  }) async {
    try {
      final options = await _authOptions();
      final response = await _dio.patch(
        '/addresses/$id',
        options: options,
        data: {
          'name':    name,
          'phone':   phone.replaceAll('+91', '').trim(),
          'house':   house,
          'pincode': pincode,
        },
      );
      log('EDIT RESPONSE => ${response.data}');
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw Exception('Failed to update address');
      }
    } on DioException catch (e) {
      log('EDIT ADDRESS ERROR => ${e.response?.data}');
      throw ErrorHandler.handle(e);
    }
  }
}