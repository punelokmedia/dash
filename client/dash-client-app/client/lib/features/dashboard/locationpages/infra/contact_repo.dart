import 'dart:developer';


import 'package:dash_logistics/core/errors/error_handler.dart';
import 'package:dash_logistics/features/dashboard/locationpages/domain/contact_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactRepository {
  final Dio dio;
  ContactRepository(this.dio);

  Future<void> submitContact(ContactModel model) async {
    try {
      // ✅ Dummy API call — replace with real endpoint
      final response = await dio.post(
        'api/contact/save',
        data: model.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw response.data['message'] ?? 'Failed to save contact';
      }

      log('submitContact success: ${response.data}');
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}

final contactRepositoryProvider = Provider<ContactRepository>(
  (ref) => ContactRepository(Dio()),
);