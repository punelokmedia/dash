// infra/trip_controller.dart
import 'dart:developer';

import 'package:dash_logistics/features/dashboard/trip_details/domain/trip_state.dart';
import 'package:dash_logistics/features/dashboard/trip_details/infra/trip_repository.dart';
import 'package:dash_logistics/features/dashboard/trip_details/shared/trip_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class TripController extends StateNotifier<TripState> {
  final Ref _ref;

  TripController(this._ref) : super(const TripState());

  TripRepository get _repo => _ref.read(tripRepositoryProvider);

  Future<void> loadTrip(String tripId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final trip = await _repo.fetchTripDetails(tripId);
      state = trip.copyWith(isLoading: false);
    } catch (e) {
      log('TripController error: $e');
      state = state.copyWith(
        isLoading:    false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        // ✅ Fallback dummy data so UI still renders
        tripId:       tripId,
        status:       'Searching for drivers nearby...',
        pickupName:   'Suresh jadhav.',
        pickupPhone:  '7214512511',
        pickupAddress:'Gujar Nimbalkar nagar, Maharashtra, Inadia',
        dropName:     'Suresh jadhav.',
        dropPhone:    '7214512511',
        dropAddress:  'Gujar Nimbalkar nagar, Maharashtra, Inadia',
      );
    }
  }

  void clearError() => state = state.clearError();
}