import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/order_card.dart';

class OngoingOrders extends StatelessWidget {
  const OngoingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 6, bottom: 16),
      children: [

        // ── Card 1: Current Order ──────────────────────────────────────
        // Status: green, left button: green outline, right: green fill
        OrderCard(
          orderId: "PR038276",
          status: "Current Order",
          statusColor: AppColors.color159,
          amount: "3056",
          date: "27-02-2026",
          leftButton: "Current Order",
          rightButton: "Track Order",
          leftButtonTextColor: AppColors.color159,
          leftButtonBorderColor: AppColors.color159,
        ),

        // ── Card 2: Canceled ──────────────────────────────────────────
        // Status: red, left button: red outline+text, right: green fill
        OrderCard(
          orderId: "PR038276",
          status: "Canceled",
          statusColor: AppColors.red241,
          amount: "3056",
          date: "27-02-2026",
          leftButton: "Canceled Order",
          rightButton: "Order Again",
          leftButtonTextColor: AppColors.red241,
          leftButtonBorderColor: AppColors.red241,
        ),
      ],
    );
  }
}