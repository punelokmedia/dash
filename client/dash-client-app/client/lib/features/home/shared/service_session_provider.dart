// providers/service_session_provider.dart
import 'dart:developer';

import 'package:dash_logistics/core/network/dio_provider.dart';
import 'package:dash_logistics/core/storage/storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

enum ServiceType { WITHIN_CITY, OUTSTATION }

class ServiceSessionState {
  final bool     isLoading;
  final String?  error;
  final Map<String, dynamic>? sessionData;

  const ServiceSessionState({
    this.isLoading  = false,
    this.error,
    this.sessionData,
  });

  ServiceSessionState copyWith({
    bool?   isLoading,
    String? error,
    Map<String, dynamic>? sessionData,
  }) => ServiceSessionState(
    isLoading:   isLoading   ?? this.isLoading,
    error:       error,
    sessionData: sessionData ?? this.sessionData,
  );
}

class ServiceSessionNotifier extends StateNotifier<ServiceSessionState> {
  final Ref _ref;
  ServiceSessionNotifier(this._ref) : super(const ServiceSessionState());

  Future<bool> createSession(ServiceType serviceType) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // ✅ get token from your SecureStorageProvider
      final storage = _ref.read(secureStorageProvider);
      final token = await storage.read(key: 'token') ?? '';

      final dio = _ref.read(dioProvider);

      final response = await dio.post(
        'booking/session',
        data: {
          'serviceType': serviceType.name, // 'WITHIN_CITY' or 'OUTSTATION'
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type':  'application/json',
          },
        ),
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        state = state.copyWith(
          isLoading:   false,
          sessionData: response.data['data'],
        );
        log(response.toString());
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        error:     response.data['message'] ?? 'Something went wrong',
      );
      return false;

    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:     e.response?.data['message'] ?? e.message ?? 'Network error',
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final serviceSessionProvider =
    StateNotifierProvider<ServiceSessionNotifier, ServiceSessionState>(
  (ref) => ServiceSessionNotifier(ref),
);