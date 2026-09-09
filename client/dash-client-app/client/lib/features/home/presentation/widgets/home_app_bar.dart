import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String location;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    super.key,
    required this.location,
    required this.onLocationTap,
    required this.onNotificationTap,
    required this.onProfileTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      shadowColor: Colors.black12,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            // ── Dash logo pill ─────────────────────────────
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  'assets/Icons/home/home_appbar_icon.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Center(
                    child: Icon(Icons.local_shipping_outlined,
                        color: const Color(0xFF4CAF50), size: 22.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),

            // ── Location ───────────────────────────────────
            Expanded(
              child: GestureDetector(
                onTap: onLocationTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your Location',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: AppTextStyles.fontFamilyRoboto,
                        color: AppColors.black37,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            location.isEmpty ? 'Select location' : location,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: AppTextStyles.fontFamilyRoboto,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            size: 18.r, color: Colors.black54),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Notification bell ──────────────────────────
            GestureDetector(
              onTap: onNotificationTap,
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.white,
                ),
                child: Image.asset(
                  "assets/Icons/home/notification.png",
                  height: 20.h,
                  width:17.w
                  ),
              ),
            ),
            SizedBox(width: 8.w),

            // ── Profile avatar ─────────────────────────────
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.white,
                ),
                child: Image.asset(
                  "assets/Images/payment/profile.png",
                  height: 20.h,
                  width: 20.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}