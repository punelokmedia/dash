import 'package:dash_logistics/core/network/dio_provider.dart';
import 'package:dash_logistics/features/dashboard/profile/domain/models/profile_state.dart';
import 'package:dash_logistics/features/dashboard/profile/infra/profile_controller.dart';
import 'package:dash_logistics/features/dashboard/profile/infra/profile_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

/// Repository — gets Dio from dioProvider (baseUrl lives there)
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRepositoryImpl(dio);
});

/// Controller
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController(ref);
});