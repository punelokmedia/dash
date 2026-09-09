import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class GstCard extends StatelessWidget {
  const GstCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section title ─────────────────────────────────
        Text(
          "GST Details",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 8.h),

        // ── Green card ────────────────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.lemongreen,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: -3,
                color: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── GST icon ──────────────────────────────────
              Image.asset(
                "assets/Images/receipt_gst.png",
                height: 48.h,
                width: 48.w,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.receipt_long,
                  size: 40.sp,
                  color: Colors.white70,
                ),
              ),

              SizedBox(width: 12.w),

              // ── Text block ────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Have a GST Number",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Update in easy steps",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Free 50 mins of loading-\nuploading time inclindded",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.sp,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Add GSTIN button ─────────────────────────
              SizedBox(
                height: 36.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.lemongreen,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Add GSTIN",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Divider below GST card ────────────────────────
        SizedBox(height: 16.h),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}