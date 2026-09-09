import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class TripHeader extends StatelessWidget {
  final String tripId;
  const TripHeader({super.key, required this.tripId});
  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.lemon,
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + 8.h,
      left: 16.w,
      right: 16.w,
      bottom: 14.h,
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            'Trip $tripId',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              fontFamily: AppTextStyles.fontFamilyRoboto,
            ),
          ),
        ),
        Icon(Icons.share_outlined, color: AppColors.white, size: 21.sp),
      ],
    ),
  );
}
