import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AddressTile extends StatelessWidget {
  /// [showSave] — show the grey "Save" text on the right
  final bool showSave;
  const AddressTile({super.key, this.showSave = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Shop',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamilyRoboto,
                      fontSize:   12.sp,
                      fontWeight: FontWeight.w500,
                      color:      AppColors.black37)),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color:        Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text('Sureshjadhav',
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.black37,fontFamily: AppTextStyles.fontFamilyRoboto,)),
              ),
              const Spacer(),
              if (showSave)
                Text('Save',
                    style: TextStyle(
                        fontSize:   12.sp,
                        color:      AppColors.grey120,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppTextStyles.fontFamilyRoboto
                      )),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Gujar Nimbalkar nagar, Maharashtra, Inadia',
            style: TextStyle(
              fontSize: 12.sp, 
              color: AppColors.grey120,
              fontFamily: AppTextStyles.fontFamilyRoboto
              ),
          ),
          Divider(height: 18.h, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}