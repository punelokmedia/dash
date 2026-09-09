import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104.h,
      width: 371.w,
      padding: EdgeInsets.all(10.r),
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
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/vehicles/tata_ace.png", height: 53.h),
          SizedBox(width: 36.w),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Text(
                "3 Wheeler",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  fontFamily: AppTextStyles.fontFamilyRoboto,
                ),
              ),
              Text(
                "View Address \nDetails",
                style: TextStyle(color: AppColors.grey120),
              ),
            ],
          ),
          const Spacer(),
          const Text("16 mins away", style: TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
