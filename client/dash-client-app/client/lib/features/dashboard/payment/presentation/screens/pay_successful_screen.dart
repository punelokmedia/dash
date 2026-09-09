import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaySuccessfulScreen extends ConsumerWidget{
  const PaySuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref){
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Container(
                height: 68.h,
                color: AppColors.lemon,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,vertical: 14.h
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        context.pop();
                      },
                      child: Icon(Icons.arrow_back_ios,color: AppColors.white,size: 20.sp,),
                    ),
                    SizedBox(width: 10.w,),
                    Text("Successful",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppTextStyles.fontFamilyInter,
                      color: AppColors.white
                    ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 116.h,),
                    Container(
                      width: 79.w,
                      height: 79.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lemon  
                      ),
                      child: Icon(Icons.check,size: 44.sp,color: AppColors.white,),
                    ),
                    SizedBox(height: 13.h,),
                    Text(
                      "Payment Successful",
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamilyRoboto,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black37
                      ),
                    ),
                    SizedBox(height: 6.h,),
                    Text(
                      "Track your order on the",
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamilyRoboto,
                        fontSize: 16.sp,
                        color: AppColors.grey120,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      "Order Tracking page.",
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamilyRoboto,
                        fontSize: 16.sp,
                        color: AppColors.grey120,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(height: 130.h,),
                    Image.asset(
                      "assets/Images/payment/payment_successful.png",
                      width: 146.w,
                      height: 146.h,
                    ),
                    SizedBox(height:26.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lemon,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r)
                          )
                        ),
                        onPressed: (){},
                        child:Text(
                          "Track order",
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamilyInter,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            color: AppColors.white
                          ),
                        ) 
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    GestureDetector(
                      child: Container(
                        height: 58.h,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey223),
                          borderRadius: BorderRadius.circular(62.r)
                        ),
                        child: Text(
                          "SKIP",
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamilyInter,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey180
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      );
  }
}