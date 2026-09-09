import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class TripMapView extends StatelessWidget {
  const TripMapView({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 379.h,
    width: double.infinity,
    color: const Color(0xFFE8EAE6),
    child: Image.asset(
      'assets/Images/map_placeholder.png',
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Center(
        child: Icon(
          Icons.map_outlined,
          size: 60.sp,
          color: Colors.grey.shade400,
        ),
      ),
    ),
  );
}
