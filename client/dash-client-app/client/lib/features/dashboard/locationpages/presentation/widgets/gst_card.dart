import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class GstCard extends StatelessWidget {
  const GstCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 113.h,
      width: 371.w,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lemongreen,
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
          Image.asset("assets/images/receipt_gst.png"),
          // const Icon(Icons.receipt_long, size: 40, color: Colors.white),
          SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Have a GST Number\nUpdate in easy steps",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Add GSTIN")),
        ],
      ),
    );
  }
}
