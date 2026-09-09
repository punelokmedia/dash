import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String amount;
  final String date;
  final String leftButton;
  final String rightButton;
  final Color statusColor;

  // Optional: override left button text color (e.g. red for "Canceled Order")
  final Color? leftButtonTextColor;
  final Color? leftButtonBorderColor;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.amount,
    required this.date,
    required this.leftButton,
    required this.rightButton,
    required this.statusColor,
    this.leftButtonTextColor,
    this.leftButtonBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve left button colors
    final lbTextColor   = leftButtonTextColor  ?? const Color(0xff9DBB2F);
    final lbBorderColor = leftButtonBorderColor ?? const Color(0xff9DBB2F);

    return Container(
      // Figma: width 379, height 148, margin left 12px, radius 20px
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        // Figma shadow: x=0 y=4 blur=4 spread=0 rgba(0,0,0,0.25)
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000), // rgba(0,0,0,0.25)
            blurRadius: 4,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Order ID ─────────────────────────────────────────────────
          Text(
            "Order ID : $orderId",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppTextStyles.fontFamilyRoboto,
              color: AppColors.black,
            ),
          ),

          SizedBox(height: 6.h),

          // ── Status + Date ────────────────────────────────────────────
          Row(
            children: [
              Text(
                "Status : ",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.grey143,
                  fontFamily: AppTextStyles.fontFamilyRoboto,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: statusColor,
                  fontFamily: AppTextStyles.fontFamilyRoboto,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                "Date : $date",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.grey143,
                  fontFamily: AppTextStyles.fontFamilyRoboto,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          // ── Total Amount ─────────────────────────────────────────────
          Text(
            "Total Amount : $amount",
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.grey143,
              fontFamily: AppTextStyles.fontFamilyRoboto,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: 14.h),

          // ── Buttons ──────────────────────────────────────────────────
          Row(
            children: [
              // Left outlined pill button
              Expanded(
                child: SizedBox(
                  height: 38.h,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: lbBorderColor, width: 1.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      leftButton,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: lbTextColor,
                        fontFamily: AppTextStyles.fontFamilyRoboto,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              // Right filled pill button
              Expanded(
                child: SizedBox(
                  height: 38.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color159,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      rightButton,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppColors.white,
                        fontFamily: AppTextStyles.fontFamilyRoboto,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}