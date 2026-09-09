import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/features/dashboard/address/domain/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class EditAddressMap extends StatelessWidget {
  final AddressModel address;
  const EditAddressMap({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 358.h,
      child: Stack(
        children: [
          // Map placeholder — replace with google_maps_flutter widget
          Container(
            color: const Color(0xFFE8E8E8),
            child: const Center(child: Icon(Icons.map, size: 60, color: Colors.grey)),
          ),

          // Address chip at bottom
          Positioned(
            bottom: 10, left: 10, right: 10,
            child: Container(
              height: 61.h,
              padding: EdgeInsets.only(left: 30.h,top:10.h,right: 30.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.house,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp,fontFamily: AppTextStyles.fontFamilyInter),
                        ),
                        Text(
                          '${address.address}, ${address.pincode}',
                          style: TextStyle(fontSize: 14.sp, fontFamily: AppTextStyles.fontFamilyRoboto,color:AppColors.grey117),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    height: 29.h,
                    width: 61.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                        color: AppColors.blueColor26
                      )
                    ),
                    child: Text(
                      "Change",
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamilyRoboto,
                        fontSize: 14.sp,
                        color: AppColors.blueColor26,
                        fontWeight: FontWeight.w400
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