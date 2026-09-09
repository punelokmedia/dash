import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/features/dashboard/payment/presentation/screens/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TrackOrder extends HookConsumerWidget {
  const TrackOrder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lemon,
        leading: Icon(
          Icons.arrow_back_ios,
          size: 20.sp,
          color: AppColors.white,
        ),
        title: Text(
          "Track Order",
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamilyRoboto,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              // height: 500.h,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 220.h,
                    left: 0.h,
                    right: 0.h,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return const RateBottomSheet();
                          },
                        );
                      },
                      child: Container(
                        height: 58.h,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: AppColors.buttonLemon,
                          borderRadius: BorderRadius.circular(62.r),
                        ),
                        child: Text(
                          "Arrived",
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamilyInter,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.h,
                    left: 0.h,
                    right: 0.h,
                    child: Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 0,
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                          ),
                        ],
                        border: Border.all(color: AppColors.white231),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 39.h,
                            margin: EdgeInsets.fromLTRB(47, 27, 14, 39),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.grey217,
                            ),
                            child: Image.asset(
                              "assets/Images/payment/profile.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Deepak Sharma\n",
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamilyRoboto,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "Delivery Boy",
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamilyRoboto,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 57.w),
                          Image.asset(
                            "assets/Icons/vehicles/call_icon.png",
                            height: 30.h,
                            width: 30.w,
                          ),
                          SizedBox(width: 10.w),
                          Image.asset(
                            "assets/Icons/vehicles/message.png",
                            height: 30.h,
                            width: 30.w,
                          ),
                          // Container(
                          //   height: 27.h,
                          //   width: 27.w,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: Color.fromRGBO(129, 196, 93, 1),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         offset: Offset(0, 1),
                          //         blurRadius: 2.5,
                          //         spreadRadius: 0,
                          //       ),
                          //     ],
                          //   ),
                          //   child: Icon(
                          //     Icons.call,
                          //     size: 11.sp,
                          //     color: AppColors.white,
                          //   ),
                          // ),
                          // SizedBox(width: 10.w),
                          // Container(
                          //   height: 27.h,
                          //   width: 27.w,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: AppColors.white,
                          //     boxShadow: [
                          //       BoxShadow(
                          //         offset: Offset(0, 1),
                          //         blurRadius: 2.5,
                          //         spreadRadius: 0,
                          //       ),
                          //     ],
                          //   ),
                          //   child: Icon(
                          //     Icons.message,
                          //     size: 11.sp,
                          //     color: AppColors.black,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
