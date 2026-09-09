// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AnimatedScooter extends HookWidget {
  const AnimatedScooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final controller = useAnimationController(
      duration: const Duration(seconds: 4),
    );

    final animation = useAnimation(
      Tween<double>(
        begin: -120.w,
        end: screenWidth,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear)),
    );

    /// start animation
    useEffect(() {
      controller.repeat();
      return null;
    }, []);

    return SizedBox(
      height: 120.h,
      child: Stack(
        children: [
          Positioned(
            left: animation,
            bottom: 0,
            child: Image.asset(
              "assets/Images/biker.png",
              height: 110.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
