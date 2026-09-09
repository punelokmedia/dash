import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ToggleSwitch extends StatelessWidget {
  final bool isOngoing;
  final Function(bool) onToggle;

  const ToggleSwitch({
    super.key,
    required this.isOngoing,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 40.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.color159),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          /// ONGOING
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isOngoing ? AppColors.color159 : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "Ongoing",
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamilyRoboto,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.sp,
                    color: isOngoing ? AppColors.white : AppColors.color159,
                  ),
                ),
              ),
            ),
          ),

          /// HISTORY
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isOngoing ? AppColors.color159 : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "History",
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamilyRoboto,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.sp,
                    color: !isOngoing ? AppColors.white : AppColors.color159,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
