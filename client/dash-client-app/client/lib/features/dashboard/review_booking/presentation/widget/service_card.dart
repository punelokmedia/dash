import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section title ─────────────────────────────────
        Text(
          "Add Services",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 8.h),

        // ── Card ─────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: -3,
                color: const Color.fromRGBO(0, 0, 0, 0.15),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Service image ───────────────────────────
              Image.asset(
                "assets/Images/service.png",
                height: 64.h,
                width: 64.w,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.handyman_outlined,
                  size: 40.sp,
                  color: Colors.grey.shade400,
                ),
              ),

              SizedBox(width: 12.w),

              // ── Service details ─────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Strong Hands. Safe Moves.",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Reliable loading and unloading support.",
                      style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                    ),
                    SizedBox(height: 2.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 11.sp),
                        children: [
                          TextSpan(
                            text: "Start@ ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextSpan(
                            text: "₹10 per item",
                            style: TextStyle(
                              color: AppColors.lemongreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 11.sp),
                        children: [
                          TextSpan(
                            text: "Earliest pickup in ",
                            style: TextStyle(color: Colors.black45),
                          ),
                          TextSpan(
                            text: "30 min",
                            style: TextStyle(
                              color: AppColors.lemongreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              // ── Add button ──────────────────────────────
              SizedBox(
                width: 53.w,
                height: 32.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(
                      0xFF1656E1,
                    ), // rgba(22, 86, 225, 1)
                    padding: EdgeInsets.zero,
                    side: const BorderSide(
                      color: Color(0xFF1656E1), // 1px blue border
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        7.r,
                      ), // 7px radius from Figma
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1656E1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
