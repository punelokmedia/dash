
enum PaymentStatus { idle, loading, success, failed }
 
class PaymentState {
  final PaymentStatus status;
  final String?       error;
  final String?       paymentId;
 
  const PaymentState({
    this.status    = PaymentStatus.idle,
    this.error,
    this.paymentId,
  });
 
  PaymentState copyWith({
    PaymentStatus? status,
    String?        error,
    String?        paymentId,
  }) =>
      PaymentState(
        status:    status    ?? this.status,
        error:     error,           // null intentionally clears error
        paymentId: paymentId ?? this.paymentId,
      );
}