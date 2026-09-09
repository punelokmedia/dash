// ignore_for_file: depend_on_referenced_packages, unused_import

import 'dart:developer';

import 'package:dash_logistics/core/storage/storage_provider.dart';
import 'package:dash_logistics/features/dashboard/profile/domain/models/profile_state.dart';
import 'package:dash_logistics/features/dashboard/profile/infra/profile_repository.dart';
import 'package:dash_logistics/features/dashboard/profile/shared/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/legacy.dart';

class ProfileController extends StateNotifier<ProfileState> {
  final Ref _ref;

  ProfileController(this._ref) : super(const ProfileState());

  FlutterSecureStorage get _storage => _ref.read(secureStorageProvider);

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final allKeys = await _storage.readAll();

      log('ALL storage entries with values: $allKeys'); // ✅ shows key + value

      final token = await _storage.read(key: 'token');
      

      // log("token value: $token");
      
      if (token == null || token.isEmpty) {
        throw Exception('No token found. Please log in again.');
      }

      final repo = _ref.read(profileRepositoryProvider);
      final profile = await repo.fetchProfile(token);

      state = state.copyWith(isLoading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void clearError() => state = state.clearError();
}
