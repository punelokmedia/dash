import 'package:dash_logistics/core/network/dio_provider.dart';
import 'package:dash_logistics/core/storage/storage_provider.dart';

import 'package:dash_logistics/features/home/domain/models/home_state.dart';
import 'package:dash_logistics/features/home/infra/home_controller.dart';
import 'package:dash_logistics/features/home/infra/home_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider),
  );
});

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(ref.watch(homeRepositoryProvider));
});