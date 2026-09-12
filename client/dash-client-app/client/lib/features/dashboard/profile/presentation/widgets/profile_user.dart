import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ProfileUserCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onEdit;

  const ProfileUserCard({
    super.key,
    required this.name,
    required this.email,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circle
          CircleAvatar(
            radius: 34.r,
            backgroundColor: AppColors.lemon.withValues(alpha: 0.15),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.lemon,
              ),
            ),
          ),
          SizedBox(width: 14.w),

          // Name + email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color.fromRGBO(214, 214, 214, 1),
                  ),
                ),
              ],
            ),
          ),

          // Edit button
          GestureDetector(
            onTap: onEdit,
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.lemon,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
