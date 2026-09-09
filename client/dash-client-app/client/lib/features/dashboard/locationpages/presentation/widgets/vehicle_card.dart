// ignore_for_file: unnecessary_underscores

import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class VehicleCard extends StatelessWidget {
  final String       title;
  final String       weight;
  final String       time;
  final String       price;
  final String       image;
  final bool         isSelected;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.title,
    required this.weight,
    required this.time,
    required this.price,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 124.h,
        width: 347.w,
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? AppColors.blue10
                : AppColors.white231,
            width: 1,
          ),
        ),
        child: Stack(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 22.w, vertical: 32.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Vehicle image
                  SizedBox(
                    width:  112.w,
                    height: 53.h,
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                          Icons.local_shipping_outlined,
                          size: 40.sp,
                          color: Colors.grey.shade400),
                    ),
                  ),

                  SizedBox(width: 27.w),

                  // Title + weight/time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize:   16.sp,
                            fontWeight: FontWeight.w600,
                            color:      AppColors.black,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          '$weight, $time',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color:    AppColors.grey120,
                              fontFamily: AppTextStyles.fontFamilyRoboto
                            ),
                        ),
                      ],
                    ),
                  ),

                  // Price
                  Text(
                    price,
                    style: TextStyle(
                      fontSize:   14.sp,
                      fontWeight: FontWeight.w600,
                      color:      AppColors.black,
                      fontFamily: AppTextStyles.fontFamilyRoboto
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Blue dot top-left on selected card
            if (isSelected)
              Positioned(
                top:  8.h,
                left: 8.w,
                child: Container(
                  width:  8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A57FF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}