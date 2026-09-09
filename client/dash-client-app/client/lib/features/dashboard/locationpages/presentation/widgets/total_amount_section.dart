import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class TotalAmountSection extends StatelessWidget {
  const TotalAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Row(
          children: [
            Image.asset(
              "assets/images/Banknotes.png",
              height: 36.h,
              width: 34.w,
            ),
            Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            Text("₹455", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 58,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lemongreen,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () {},
            child: const Text("Next"),
          ),
        ),
      ],
    );
  }
}
