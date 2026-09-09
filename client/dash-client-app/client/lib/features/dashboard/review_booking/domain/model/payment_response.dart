
class PaymentVerifyResponse {
  final bool   success;
  final String message;
 
  const PaymentVerifyResponse({required this.success, required this.message});
 
  factory PaymentVerifyResponse.fromJson(Map<String, dynamic> json) =>
      PaymentVerifyResponse(
        success: json['success'] as bool? ?? false,
        message: json['message'] as String? ?? '',
      );
}
 