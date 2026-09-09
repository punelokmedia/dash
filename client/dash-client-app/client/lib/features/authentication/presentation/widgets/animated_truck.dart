// ignore_for_file: unnecessary_underscores, depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AnimatedTruckOnCurve extends HookWidget {
  final double height;
  const AnimatedTruckOnCurve({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final moveCtrl = useAnimationController(
      duration: const Duration(seconds: 4),
    );
    final bounceCtrl = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    // Truck enters from right, exits off left
    final moveAnim = useAnimation(
      Tween<double>(begin: screenWidth, end: -180.w).animate(
        CurvedAnimation(parent: moveCtrl, curve: Curves.linear),
      ),
    );

    // Subtle road-bump bounce (vertical only)
    final bounceAnim = useAnimation(
      Tween<double>(begin: 0, end: -3.h).animate(
        CurvedAnimation(parent: bounceCtrl, curve: Curves.easeInOut),
      ),
    );

    useEffect(() {
      moveCtrl.repeat();
      bounceCtrl.repeat(reverse: true);
      return null;
    }, [moveCtrl, bounceCtrl]);

    final truckW = 167.w;

    return SizedBox(
      width: double.infinity,
      height: height, // exactly 105.h — no extra space above or below
      child: AnimatedBuilder(
        animation: Listenable.merge([moveCtrl, bounceCtrl]),
        builder: (_, __) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Shadow — bottom: 0 puts it ON the curve line
              Positioned(
                bottom: 0,
                left: moveAnim + 18.w,
                child: Opacity(
                  opacity: _opacity(moveAnim, screenWidth),
                  child: Container(
                    width: truckW * 0.72,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                ),
              ),

              // Truck — bottom: 0 means wheels rest exactly on curve
              Positioned(
                bottom: 0,
                left: moveAnim,
                child: Transform.translate(
                  offset: Offset(0, bounceAnim),
                  child: Image.asset(
                    'assets/Icons/login_icon.png',
                    height: height,
                    width: truckW,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _opacity(double x, double screenWidth) {
    final fade = screenWidth * 0.15;
    if (x > screenWidth - fade) return ((screenWidth - x) / fade).clamp(0.0, 1.0);
    if (x < fade) return ((x + 180.0) / fade).clamp(0.0, 1.0);
    return 1.0;
  }
}