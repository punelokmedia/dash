import 'package:delivary_partner/authentication/registration/infra/vehicle_registration.dart';
import 'package:hooks_riverpod/legacy.dart';

// final vehicleRegistrationProvider = StateNotifierProvider<
//     VehicleRegistrationNotifier, VehicleRegistrationState>(
//   (ref) => VehicleRegistrationNotifier(),
// );


final vehicleRegistrationProvider = StateNotifierProvider<
    VehicleRegistrationNotifier, VehicleRegistrationState>(
  (ref) => VehicleRegistrationNotifier(ref), // ✅ ref injected here
);