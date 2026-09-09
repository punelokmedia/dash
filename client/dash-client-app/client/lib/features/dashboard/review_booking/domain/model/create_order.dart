
class CreateOrderResponse {
  final String razorpayOrderId;
  final int    amountInPaise;
  final String currency;
  final String orderId; // your internal order id
 
  const CreateOrderResponse({
    required this.razorpayOrderId,
    required this.amountInPaise,
    required this.currency,
    required this.orderId,
  });
 
  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    // Adjust field names to match your actual API response
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return CreateOrderResponse(
      razorpayOrderId: data['razorpayOrderId'] as String? ??
                       data['id']              as String? ?? '',
      amountInPaise:   (data['amount'] as num?)?.toInt() ?? 0,
      currency:        data['currency'] as String? ?? 'INR',
      orderId:         data['orderId'] as String? ?? '',
    );
  }
}