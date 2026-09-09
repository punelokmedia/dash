// lib/features/dashboard/add_address/infra/address_repository.dart

import 'dart:developer';

import 'package:dash_logistics/core/errors/error_handler.dart';
import 'package:dash_logistics/core/network/dio_provider.dart';
import 'package:dash_logistics/core/storage/storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// Add this class at the top of address_repository.dart
class AddressException implements Exception {
  final String message;
  const AddressException(this.message);

  @override
  String toString() => message; // ← returns clean message, not "Exception: ..."
}

class AddressRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage; // ← injected, not created here

  AddressRepository(this._dio, this._storage); // ← add storage param

  Future<Options> _authOptions() async {
    final token = await _storage.read(key: 'token') ?? '';
    debugPrint('[AddressRepo] token from storage: $token'); // temp debug
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<String> getSavedPhone() async =>
      await _storage.read(key: 'phone') ?? '';

  Future<void> saveAddress({
    required String label,
    required String name,
    required String phone,
    required String house,
    required String address,
    required String pincode,
    required double latitude,
    required double longitude,
  }) async {
    log(label);
    log(name);
    log(phone.replaceAll('+91', '').replaceAll(' ', ''));
    log(house);
    log(address);
    log(pincode);

    final options = await _authOptions();
    print('OPTIONS => ${options.headers}');
    try {
      final response = await _dio.post(
        '/addresses',
        data: {
          'label': label,
          'name': name,
          'phone': phone.replaceAll('+91', '').replaceAll(' ', ''),
          'house': house,
          'address': address,
          'pincode': pincode,
        },
        options: options,
      );
      log('RESPONSE => ${response.data}');
    } on DioException catch (e) {
      log('ERROR BODY => ${e.response?.data}');

      throw ErrorHandler.handle(e); // ← replaces rethrow
    }
  }
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(
    ref.read(dioProvider),
    ref.read(secureStorageProvider), // ← inject from shared provider
  );
});
