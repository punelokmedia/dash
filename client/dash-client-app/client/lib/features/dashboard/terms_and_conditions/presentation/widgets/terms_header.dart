import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class TermsHeader extends StatelessWidget {
  const TermsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 100.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22.sp),
            ),

            SizedBox(width: 12.w),

            Text(
              "Terms & Conditions",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22.sp,
                fontWeight: FontWeight(600),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
