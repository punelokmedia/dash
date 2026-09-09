
import 'package:dash_logistics/features/dashboard/review_booking/domain/state/payment_state.dart';
import 'package:dash_logistics/features/dashboard/review_booking/infra/payment_repository.dart';

import 'package:hooks_riverpod/legacy.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentController extends StateNotifier<PaymentState> {
  final PaymentRepository _repo;
  late final Razorpay     _razorpay;
 
  /// Set these before calling [initiatePayment]
  void Function(String paymentId)? onSuccess;
  void Function(String error)?     onFailure;
 
  PaymentController(this._repo) : super(const PaymentState()) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,   _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
 
  // ── Initiate payment ──────────────────────────────────────────────────────
  Future<void> initiatePayment({
    required String orderId,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String razorpayKeyId,
    String description = 'Dash Logistics Delivery',
  }) async {
    state = state.copyWith(status: PaymentStatus.loading);
 
    try {
      // 1. Call backend to create Razorpay order
      final orderRes = await _repo.createOrder(orderId);
 
      // 2. Build checkout options
      // razorpay_flutter 1.4.1 — all values must be the correct type:
      // amount  → int (paise)
      // timeout → int (seconds), optional
      final Map<String, dynamic> options = {
        'key':         razorpayKeyId,
        'amount':      orderRes.amountInPaise,    // int, in paise
        'currency':    orderRes.currency,         // 'INR'
        'order_id':    orderRes.razorpayOrderId,  // from backend
        'name':        'Dash Logistics',
        'description': description,
        'timeout':     300,                       // 5 minutes
        'prefill': {
          'contact': customerPhone,
          'email':   customerEmail,
          'name':    customerName,
        },
        'theme': {
          'color': '#71C462',                     // brand green
        },
      };
 
      _razorpay.open(options);
      // Note: loading state stays true until a callback fires
    } catch (e) {
      state = state.copyWith(
        status: PaymentStatus.failed,
        error:  e.toString(),
      );
      onFailure?.call(e.toString());
    }
  }
 
  // ── razorpay_flutter 1.4.1 callback signatures ────────────────────────────
 
  /// Called when payment is successful.
  /// In 1.4.1, [PaymentSuccessResponse] has:
  ///   • paymentId  → String?
  ///   • orderId    → String?
  ///   • signature  → String?
  void _handleSuccess(PaymentSuccessResponse response) async {
    try {
      await _repo.verifyPayment(
        razorpayOrderId:   response.orderId   ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      );
 
      state = state.copyWith(
        status:    PaymentStatus.success,
        paymentId: response.paymentId,
      );
      onSuccess?.call(response.paymentId ?? '');
    } catch (e) {
      state = state.copyWith(
        status: PaymentStatus.failed,
        error:  'Verification failed: $e',
      );
      onFailure?.call('Verification failed: $e');
    }
  }
 
  /// Called when payment fails or is dismissed.
  /// In 1.4.1, [PaymentFailureResponse] has:
  ///   • code    → int?
  ///   • message → String?
  ///   • error   → Map<dynamic, dynamic>?  ← NEW in 1.4.x
  void _handleError(PaymentFailureResponse response) {
    // 1.4.1 exposes a richer error map — extract description if present
    String msg = response.message ?? 'Payment failed';
    if (response.error != null) {
      final desc = response.error!['description'];
      if (desc != null && desc.toString().isNotEmpty) {
        msg = desc.toString();
      }
    }
 
    state = state.copyWith(status: PaymentStatus.failed, error: msg);
    onFailure?.call(msg);
  }
 
  /// Called when user selects an external wallet (e.g. PayZapp).
  /// In 1.4.1, [ExternalWalletResponse] has:
  ///   • walletName → String?
  void _handleExternalWallet(ExternalWalletResponse response) {
    // Optional: log or handle external wallet selection
    // The payment will complete outside the app
    state = state.copyWith(status: PaymentStatus.idle);
  }
 
  void clearError() => state = state.copyWith(status: PaymentStatus.idle);
 
  @override
  void dispose() {
    _razorpay.clear(); // ✅ must call to release native resources
    super.dispose();
  }
}