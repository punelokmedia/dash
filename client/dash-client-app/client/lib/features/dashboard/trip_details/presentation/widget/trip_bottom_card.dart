import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/features/dashboard/trip_details/domain/trip_state.dart';
import 'package:dash_logistics/features/dashboard/trip_details/presentation/widget/trip_address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class TripBottomCard extends StatelessWidget {
  final TripState state;
  const TripBottomCard({super.key, required this.state});

  String _val(String v, String fallback) => v.isNotEmpty ? v : fallback;

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      children: [
        SizedBox(height: 16.h),
        Text(
          state.status,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
            fontFamily: AppTextStyles.fontFamilyRoboto,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Finding partner near you.',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.grey120,
            fontFamily: AppTextStyles.fontFamilyRoboto,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        Container(width: 40.w, height: 2.h, color: Colors.blue.shade300),
        SizedBox(height: 14.h),
        TripAddressCard(
          pickupName: _val(state.pickupName, 'Suresh jadhav.'),
          pickupPhone: _val(state.pickupPhone, '7214512511'),
          pickupAddress: _val(
            state.pickupAddress,
            'Gujar Nimbalkar nagar, Maharashtra, India',
          ),
          dropName: _val(state.dropName, 'Suresh jadhav.'),
          dropPhone: _val(state.dropPhone, '7214512511'),
          dropAddress: _val(
            state.dropAddress,
            'Gujar Nimbalkar nagar, Maharashtra, India',
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.list_alt_outlined, size: 18.sp, color: AppColors.black),
              SizedBox(width: 6.w),
              Text(
                'View Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontFamily: AppTextStyles.fontFamilyRoboto
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: () => context.pushNamed(AppRoutesName.reviewBookingScreenPageName),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lemon,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: Text(
              'Okay',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                fontFamily: AppTextStyles.fontFamilyInter
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 12.h),
      ],
    ),
  );
}
