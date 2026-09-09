
import 'package:dash_logistics/features/dashboard/trip_details/domain/trip_state.dart';
import 'package:dash_logistics/features/dashboard/trip_details/infra/trip_controller.dart';
import 'package:dash_logistics/features/dashboard/trip_details/infra/trip_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final tripRepositoryProvider = Provider<TripRepository>(
  (ref) => TripRepository(Dio()),
);

final tripControllerProvider =
    StateNotifierProvider<TripController, TripState>(
  (ref) => TripController(ref),
);