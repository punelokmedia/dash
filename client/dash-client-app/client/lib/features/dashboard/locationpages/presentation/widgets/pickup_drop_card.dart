// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class PickupDropCard extends StatelessWidget {
  const PickupDropCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        // ✅ Blue border around the entire card — matches screenshot
        border: Border.all(color: Colors.blue.shade400, width: 1.5),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Dots + dashed line column ─────────────────────
          Column(
            children: [
              SizedBox(height: 14.h),
              _Dot(color: Colors.green),
              _DashedLine(height: 60.h),
              _Dot(color: Colors.red),
              SizedBox(height: 12.h),
            ],
          ),

          SizedBox(width: 10.w),

          // ── Pickup + Drop fields ──────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Pickup ────────────────────────────────────
                Container(
                  width:   double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color:        Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Suresh jadhav. ',
                              style: TextStyle(
                                fontSize:   13.sp,
                                fontWeight: FontWeight.w600,
                                color:      Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: '7214512511',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color:    Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Gujar Nimbalkar nagar, Maharashtra, Inadia',
                        style: TextStyle(
                            fontSize: 11.sp,
                            color:    Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h),

                // ── Drop + plus button ────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 47.h,   // ✅ Figma: H=47px
                        child: TextField(
                          style: TextStyle(
                              fontSize: 13.sp, color: Colors.black87),
                          decoration: InputDecoration(
                            hintText:  'Where is your Drop?',
                            hintStyle: TextStyle(
                                fontSize: 13.sp,
                                color:    Colors.grey.shade400),
                            isDense:        false,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 12.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.r), // ✅ Figma: Radius=7px
                              borderSide: const BorderSide(
                                  color: Color(0xFF0A57FF), width: 1),   // ✅ Figma: rgba(10,87,255,1), 1px
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.r),
                              borderSide: const BorderSide(
                                  color: Color(0xFF0A57FF), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.r),
                              borderSide: const BorderSide(
                                  color: Color(0xFF0A57FF), width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // ✅ Grey circle + button
                    Container(
                      width:  32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add,
                          size: 18.sp, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filled circle dot ─────────────────────────────────────────────────────────
class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width:  9.w,
        height: 9.w,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

// ── Dashed vertical connector ─────────────────────────────────────────────────
class _DashedLine extends StatelessWidget {
  final double height;
  const _DashedLine({required this.height});
  @override
  Widget build(BuildContext context) {
    const dashH = 3.0;
    const gapH  = 3.0;
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