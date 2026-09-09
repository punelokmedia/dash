import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: -3,
            color: Color.fromRGBO(0, 0, 0, 0.25),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset("assets/images/service.png", fit: BoxFit.contain),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Strong Hands. Safe Moves.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Reliable loading and unloading support"),
                Text("Start @ ₹10 per item"),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Add")),
        ],
      ),
    );
  }
}
