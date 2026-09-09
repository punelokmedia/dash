
import 'package:dash_logistics/features/authentication/presentation/widgets/animated_truck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


class LoginHeader extends StatelessWidget {
  final double illustrationHeight;

  const LoginHeader({super.key, required this.illustrationHeight});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            _LogoPill(),
            SizedBox(height: 32.h),
            AnimatedTruckOnCurve(height: illustrationHeight),
          ],
        ),
      ),
    );
  }
}

class _LogoPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/Icons/home/home_appbar_icon.png",height: 68.h,width: 170.w,);
  }
}
