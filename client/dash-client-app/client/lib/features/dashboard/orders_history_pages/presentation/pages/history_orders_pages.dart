import 'package:flutter/material.dart';
import '../widgets/order_card.dart';

class HistoryOrders extends StatelessWidget {
  const HistoryOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        OrderCard(
          orderId: "PR038276",
          status: "Delivered",
          statusColor: Colors.green,
          amount: "3056",
          date: "27-02-2026",
          leftButton: "Order Details",
          rightButton: "Book Again",
        ),

        OrderCard(
          orderId: "PR038276",
          status: "Delivered",
          statusColor: Colors.green,
          amount: "3056",
          date: "27-02-2026",
          leftButton: "Order Details",
          rightButton: "Book Again",
        ),

        OrderCard(
          orderId: "PR038276",
          status: "Delivered",
          statusColor: Colors.green,
          amount: "3056",
          date: "27-02-2026",
          leftButton: "Order Details",
          rightButton: "Book Again",
        ),
      ],
    );
  }
}
