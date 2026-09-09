import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class TripAddressCard extends StatelessWidget {
  final String pickupName, pickupPhone, pickupAddress;
  final String dropName, dropPhone, dropAddress;
  const TripAddressCard({
    super.key,
    required this.pickupName,
    required this.pickupPhone,
    required this.pickupAddress,
    required this.dropName,
    required this.dropPhone,
    required this.dropAddress,
  });
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4.h),
          _Dot(color: Colors.green),
          ...List.generate(
            8,
            (_) => Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              width: 1.5,
              height: 3.h,
              color: Colors.grey.shade400,
            ),
          ),
          _Dot(color: Colors.red),
        ],
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AddrLine(
              name: pickupName,
              phone: pickupPhone,
              address: pickupAddress,
            ),
            SizedBox(height: 10.h),
            _AddrLine(name: dropName, phone: dropPhone, address: dropAddress),
          ],
        ),
      ),
    ],
  );
}

class _AddrLine extends StatelessWidget {
  final String name, phone, address;
  const _AddrLine({
    required this.name,
    required this.phone,
    required this.address,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$name ',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
                fontFamily: AppTextStyles.fontFamilyRoboto
              ),
            ),
            TextSpan(
              text: phone,
              style: TextStyle(
                fontSize: 12.sp, 
                color: AppColors.grey120,
                fontFamily: AppTextStyles.fontFamilyRoboto,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 2.h),
      Text(
        address,
        style: TextStyle(
          fontSize: 12.sp, 
          color: AppColors.grey120,
          fontFamily: AppTextStyles.fontFamilyRoboto,
          fontWeight: FontWeight.w400
        ),
      ),
    ],
  );
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width:10.w,
    height: 10.w,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
