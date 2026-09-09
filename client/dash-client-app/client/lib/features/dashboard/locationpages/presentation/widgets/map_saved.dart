import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class MapSavedToggle extends StatelessWidget {
  const MapSavedToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ToggleItem(
            icon:  Icons.location_on,
            label: 'Select On Map',
            color: AppColors.blueColor,
          ),
          Container(width: 1, height: 18.h, color: Colors.grey.shade300),
          _ToggleItem(
            icon:  Icons.favorite,
            label: 'Saved Address',
            color: AppColors.blueColor,
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;
  const _ToggleItem({
    required this.icon, required this.label, required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 12.sp),
        SizedBox(width: 5.w),
        Text(label,
            style: TextStyle(
              fontSize: 13.sp, 
              color: AppColors.blueColor,
              fontFamily: AppTextStyles.fontFamilyRoboto,
              fontWeight: FontWeight.w500
            )),
      ],
    );
  }
}