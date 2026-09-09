import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: -3,
            color: const Color.fromRGBO(0, 0, 0, 0.15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Vehicle image ─────────────────────────────
              Image.asset(
                "assets/Icons/vehicles/tata_ace.png",
                height: 60.h,
                width: 90.w,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.local_shipping_outlined,
                  size: 50.sp,
                  color: Colors.grey.shade400,
                ),
              ),

              SizedBox(width: 12.w),

              // ── Vehicle info ──────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "3 Wheeler",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontFamily: AppTextStyles.fontFamilyRoboto,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "View Address\nDetails",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black45,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 34.h,),
              // ── ETA ───────────────────────────────────────
              Text(
                "16mins\naway",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.lemongreen,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          // ── Free time note ────────────────────────────────
          Text(
            "Free 50 mins of loading- uploading time\n inclindded",
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.lemongreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}