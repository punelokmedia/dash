import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class SupportHeader extends StatelessWidget {
  const SupportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ No fixed height — intrinsic sizing prevents overflow on all screens
      width: double.infinity,
      clipBehavior: Clip.hardEdge,   // ✅ clips image that goes outside bounds
      padding: EdgeInsets.only(
        top:   MediaQuery.of(context).padding.top + 10.h,
        left:  20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.lemon,
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          /// TEXT CONTENT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// BACK + TITLE
              Padding(
                padding: EdgeInsets.only(top: 25.r),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: ()=>context.pop(),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 18.sp),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Help & Support",
                      style: TextStyle(
                        fontSize:   22.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTextStyles.fontFamilyRoboto,
                        color:      AppColors.white,
                        height:     1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              /// DESCRIPTION
              SizedBox(
                width: 190.w,
                child: Text(
                  "Need assistance?\nChoose a topic below\n to get quick help.",
                  style: TextStyle(
                    fontSize:   18.sp,
                    fontFamily: AppTextStyles.fontFamilyRoboto,
                    color:      AppColors.white,
                    fontWeight: FontWeight.w500,
                    height:     1.5,
                  ),
                ),
              ),

              // ✅ Bottom padding replaces the negative Positioned offset
              //    gives the image space without overflowing the container
              SizedBox(height: 20.h),
            ],
          ),

          /// IMAGE (BOTTOM RIGHT)
          Positioned(
            bottom: 0,      // ✅ was -20.h (caused 29px overflow)
            right:  -5.w,
            child: Image.asset(
              "assets/Images/help_support.png",
              width:  191.w,
              height: 191.h,
              fit:    BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}