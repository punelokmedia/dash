// infra/trip_repository.dart
import 'dart:developer';
import 'package:dash_logistics/core/errors/error_handler.dart';
import 'package:dash_logistics/features/dashboard/trip_details/domain/trip_state.dart';
import 'package:dio/dio.dart';

class TripRepository {
  final Dio dio;
  TripRepository(this.dio);

  Future<TripState> fetchTripDetails(String tripId) async {
    try {
      final response = await dio.get('api/trip/$tripId');

      if (response.statusCode == 200) {
        final data = response.data;
        log('Trip details fetched: $data');
        return TripState(
          tripId:        data['trip_id']       ?? tripId,
          status:        data['status']        ?? 'Searching for drivers nearby...',
          pickupName:    data['pickup_name']   ?? '',
          pickupPhone:   data['pickup_phone']  ?? '',
          pickupAddress: data['pickup_address']?? '',
          dropName:      data['drop_name']     ?? '',
          dropPhone:     data['drop_phone']    ?? '',
          dropAddress:   data['drop_address']  ?? '',
        );
      } else {
        throw response.data['message'] ?? 'Failed to fetch trip';
      }
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}