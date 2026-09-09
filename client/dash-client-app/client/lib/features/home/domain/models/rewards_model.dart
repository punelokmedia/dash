
// ── Rewards Model ─────────────────────────────────────────
class RewardsModel {
  final int coins;
  final String message;

  RewardsModel({required this.coins, required this.message});

  factory RewardsModel.fromJson(Map<String, dynamic> json) => RewardsModel(
        coins:   (json['coins'] as num?)?.toInt() ?? 0,
        message: json['message'] as String? ?? '',
      );
}