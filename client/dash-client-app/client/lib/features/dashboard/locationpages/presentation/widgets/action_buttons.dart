import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionBtn(
            icon:  Icons.add_circle,
            label: 'Add Stop',
            onTap: () {},
            iconColor: AppColors.blueColor,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _ActionBtn(
            icon:  Icons.edit_outlined,
            label: 'Edit',
            onTap: () {},
            iconColor:AppColors.black,
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData     icon;
  final Color iconColor;
  final String       label;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon, required this.label, required this.onTap,required this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: iconColor),
            SizedBox(width: 6.w),
            Text(label,
                style: TextStyle(
                    fontSize:   16.sp,
                    fontWeight: FontWeight.w600,
                    color:      AppColors.black,
                    fontFamily: AppTextStyles.fontFamilyRoboto
                    )),
          ],
        ),
      ),
    );
  }
}