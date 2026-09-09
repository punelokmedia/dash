import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class LabelSelector extends StatelessWidget {
  final String                    selected;
  final void Function(String)     onSelect;

  static const _labels = ['Home', 'Work', 'Other'];

  const LabelSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels.map((label) {
        final isActive = label == selected;
        return Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: GestureDetector(
            onTap: () => onSelect(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
              decoration: BoxDecoration(
                color:        isActive ? AppColors.lemon : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isActive ? AppColors.lemon : Colors.grey.shade300,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize:   13.sp,
                  fontWeight: FontWeight.w600,
                  color:      isActive ? Colors.white : Colors.grey.shade600,
                  fontFamily: AppTextStyles.fontFamilyRoboto,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}