import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        // ✅ center — swap icon aligns to middle of both address rows
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // Dots + dashed line — no top SizedBox, stays aligned naturally
          Column(
            mainAxisSize:      MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Dot(color: AppColors.green87),
              _DashedLine(height: 40.h),
              _Dot(color: AppColors.red223),
            ],
          ),
          SizedBox(width: 10.w),

          // Two address rows
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AddressRow(
                  name:    'Suresh jadhav.',
                  phone:   '7214512511',
                  address: 'Gujar Nimbalkar nagar, Maharashtra, Inadia',
                ),
                SizedBox(height: 10.h),
                _AddressRow(
                  name:    'Suresh jadhav.',
                  phone:   '7214512511',
                  address: 'Gujar Nimbalkar nagar, Maharashtra, Inadia',
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // ✅ Figma: 36×36, rgba(217,217,217,1), vertically centered
          Container(
            width:  36.w,
            height: 36.w,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.swap_vert,
                size: 20.sp, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final String name, phone, address;
  const _AddressRow({
    required this.name, required this.phone, required this.address,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '$name ',
              style: TextStyle(
                  fontSize:   12.sp,
                  fontWeight: FontWeight.w600,
                  color:      Colors.black87),
            ),
            TextSpan(
              text: phone,
              style: TextStyle(
                  fontSize: 12.sp, color: Colors.grey.shade500),
            ),
          ]),
        ),
        SizedBox(height: 2.h),
        Text(address,
            style: TextStyle(
                fontSize: 11.sp, color: Colors.grey.shade500)),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width:  8.w, height: 8.w,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _DashedLine extends StatelessWidget {
  final double height;
  const _DashedLine({required this.height});
  @override
  Widget build(BuildContext context) {
    const dashH = 3.0, gapH = 3.0;
    final count = (height / (dashH + gapH)).floor();
    return SizedBox(
      width: 1.5, height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          count,
          (_) => Container(
              width: 1.5, height: dashH, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}