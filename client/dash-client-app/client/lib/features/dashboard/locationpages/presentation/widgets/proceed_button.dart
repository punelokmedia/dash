import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class ProceedButton extends StatelessWidget {
  const ProceedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left:   16.w,
        right:  16.w,
        top:    12.h,
        bottom: MediaQuery.of(context).padding.bottom + 12.h,
      ),
      child: SizedBox(
        width:  double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: () {
            context.pushNamed(AppRoutesName.tripDetailsPageName);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonLemon,
            elevation:       0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: Text(
            'Proceed',
            style: TextStyle(
              fontSize:   16.sp,
              fontWeight: FontWeight.w600,
              color:      Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}