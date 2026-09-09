import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final ratingProvider = StateProvider<int>((ref) => 1);

class RateBottomSheet extends HookConsumerWidget {
  const RateBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rating = ref.watch(ratingProvider);

    return Container(
      height: 380.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: Column(
        children: [
          /// Close Button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Icon(Icons.close, size: 20.sp),
            ),
          ),

          SizedBox(height: 10.h),

          /// Title
          Text(
            "Rate Our App",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppTextStyles.fontFamilyRoboto,
              color: AppColors.black37,
            ),
          ),

          SizedBox(height: 8.h),

          /// Subtitle
          Text(
            "How Would You Rate Our\nApp Experience?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.grey120,
              fontWeight: FontWeight.w400,
              fontFamily: AppTextStyles.fontFamilyRoboto,
            ),
          ),

          SizedBox(height: 25.h),

          /// Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  ref.read(ratingProvider.notifier).state = index + 1;
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Image.asset(
                    index < rating
                        ? "assets/Images/payment/star_filled.png"
                        : "assets/Images/payment/star.png",
                    width: 23.w,
                    height: 23.h,
                  ),
                  // child: Icon(
                  //   Icons.star,
                  //   size: 30.sp,
                  //   color: index < rating
                  //       ? Color(0xffA6C437)
                  //       : Colors.grey.shade300,
                  // ),
                ),
              );
            }),
          ),

          SizedBox(height: 40.h),

          /// Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Maybe Later
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  height: 36.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Text(
                    "May be later",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ),

              /// Submit
              Container(
                height: 36.h,
                width: 100.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffA6C437),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
