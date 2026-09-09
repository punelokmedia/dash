// domain/models/trip_state.dart

class TripState {
  final bool    isLoading;
  final String? errorMessage;
  final String  tripId;
  final String  status;
  final String  pickupName;
  final String  pickupPhone;
  final String  pickupAddress;
  final String  dropName;
  final String  dropPhone;
  final String  dropAddress;

  const TripState({
    this.isLoading    = false,
    this.errorMessage,
    this.tripId       = '',
    this.status       = 'Searching for drivers nearby...',
    this.pickupName   = '',
    this.pickupPhone  = '',
    this.pickupAddress= '',
    this.dropName     = '',
    this.dropPhone    = '',
    this.dropAddress  = '',
  });

  TripState copyWith({
    bool?   isLoading,
    String? errorMessage,
    String? tripId,
    String? status,
    String? pickupName,
    String? pickupPhone,
    String? pickupAddress,
    String? dropName,
    String? dropPhone,
    String? dropAddress,
  }) {
    return TripState(
      isLoading:     isLoading     ?? this.isLoading,
      errorMessage:  errorMessage,
      tripId:        tripId        ?? this.tripId,
      status:        status        ?? this.status,
      pickupName:    pickupName    ?? this.pickupName,
      pickupPhone:   pickupPhone   ?? this.pickupPhone,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropName:      dropName      ?? this.dropName,
      dropPhone:     dropPhone     ?? this.dropPhone,
      dropAddress:   dropAddress   ?? this.dropAddress,
    );
  }

  TripState clearError() => copyWith(errorMessage: null);
}