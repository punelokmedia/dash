import 'package:dash_logistics/core/network/dio_provider.dart';
import 'package:dash_logistics/core/storage/storage_provider.dart';
import 'package:dash_logistics/features/dashboard/review_booking/domain/state/payment_state.dart';
import 'package:dash_logistics/features/dashboard/review_booking/infra/payment_controller.dart';
import 'package:dash_logistics/features/dashboard/review_booking/infra/payment_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
 
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(
    ref.read(dioProvider),
    ref.read(secureStorageProvider),
  );
});
 
final paymentControllerProvider =
    StateNotifierProvider<PaymentController, PaymentState>(
  (ref) => PaymentController(ref.read(paymentRepositoryProvider)),
);
 