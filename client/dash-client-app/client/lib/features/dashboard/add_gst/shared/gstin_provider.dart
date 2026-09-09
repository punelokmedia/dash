// ignore_for_file: unused_import

import 'package:dash_logistics/core/network/dio_provider.dart';
import 'package:dash_logistics/core/storage/storage_provider.dart';
import 'package:dash_logistics/features/dashboard/add_gst/domain/models/gstIn_state.dart';
import 'package:dash_logistics/features/dashboard/add_gst/infra/gstController.dart';
import 'package:dash_logistics/features/dashboard/add_gst/infra/gstRepository.dart';


import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final gstinRepositoryProvider = Provider<GstinRepository>((ref) {
  final dio     = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return GstinRepositoryImpl(dio, storage);
});

final gstinControllerProvider =
    StateNotifierProvider<GstinController, GstinState>((ref) {
  final repository = ref.watch(gstinRepositoryProvider);
  return GstinController(repository);
});