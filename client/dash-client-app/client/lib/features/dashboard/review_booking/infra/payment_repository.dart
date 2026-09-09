
import 'dart:developer';

import 'package:dash_logistics/core/errors/error_handler.dart';
import 'package:dash_logistics/features/dashboard/review_booking/domain/model/create_order.dart';
import 'package:dash_logistics/features/dashboard/review_booking/domain/model/payment_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class PaymentRepository {
  Future<CreateOrderResponse> createOrder(String orderId);
  Future<PaymentVerifyResponse> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  });
}
 
class PaymentRepositoryImpl implements PaymentRepository {
  final Dio                  _dio;
  final FlutterSecureStorage _storage;
 
  PaymentRepositoryImpl(this._dio, this._storage);
 
  Future<Options> get _authOptions async {
    final token = await _storage.read(key: 'token') ?? '';
    return Options(headers: {'Authorization': 'Bearer $token'});
  }
 
  @override
  Future<CreateOrderResponse> createOrder(String orderId) async {
    try {
      final response = await _dio.post(
        '/payment/create-order',          // adjust endpoint to match your API
        data:    {'orderId': orderId},
        options: await _authOptions,
      );
      log('createOrder response: ${response.data}', name: 'Payment');
      return CreateOrderResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      log('createOrder error: ${e.response?.data}', name: 'Payment');
      throw ErrorHandler.handle(e);
    }
  }
 
  @override
  Future<PaymentVerifyResponse> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final response = await _dio.post(
        '/payment/verify',                // adjust endpoint to match your API
        data: {
          'razorpay_order_id':  razorpayOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
        },
        options: await _authOptions,
      );
      log('verifyPayment response: ${response.data}', name: 'Payment');
      return PaymentVerifyResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      log('verifyPayment error: ${e.response?.data}', name: 'Payment');
      throw ErrorHandler.handle(e);
    }
  }
}