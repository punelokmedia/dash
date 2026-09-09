import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class MapSection extends StatelessWidget{
  const MapSection({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
            height: 387.h,
            width:double.infinity,
            decoration: BoxDecoration(border: Border.all()),
            child: Stack(
              children: [
                Positioned(
                  // top: 0.h,
                  bottom: 17.h,
                  left: 0.h,
                  right: 0.h,
                  child: Container(
                    height: 61.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.white231),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                          color: Color.fromRGBO(0, 0, 0, 0.7),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 6.h, left: 30.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Home",
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamilyRoboto,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                "Gujar Nimbalkarwadi, Maharashtr...",
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamilyRoboto,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: 29.h,
                          width: 61.w,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: AppColors.blueColor26,width: 1.sp),
                          ),
                          child: Text(
                            "Change",
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamilyRoboto,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.blueColor26,
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