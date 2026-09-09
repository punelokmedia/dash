
// ── Past Order Model ──────────────────────────────────────
class PastOrderModel {
  final String id;
  final String serviceType;
  final String date;
  final double amount;
  final String imageUrl;

  PastOrderModel({
    required this.id,
    required this.serviceType,
    required this.date,
    required this.amount,
    required this.imageUrl,
  });

  factory PastOrderModel.fromJson(Map<String, dynamic> json) => PastOrderModel(
        id:          json['id']           as String,
        serviceType: json['service_type'] as String,
        date:        json['date']         as String,
        amount:      (json['amount'] as num).toDouble(),
        imageUrl:    json['image_url']    as String,
      );
}