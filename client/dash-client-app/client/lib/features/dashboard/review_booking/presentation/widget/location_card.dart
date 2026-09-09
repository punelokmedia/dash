import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: -3,
            color: const Color.fromRGBO(0, 0, 0, 0.15),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left timeline: green dot ─── dashes ─── red dot ──
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green dot
              Container(
                width: 10.w,
                height: 10.h,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),

              // Dashed connector
              SizedBox(
                height: 40.h,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const dashHeight = 4.0;
                    const dashSpace = 3.0;
                    final count =
                        (constraints.maxHeight / (dashHeight + dashSpace))
                            .floor();
                    return Column(
                      children: List.generate(
                        count,
                        (_) => Padding(
                          padding: const EdgeInsets.only(bottom: dashSpace),
                          child: Container(
                            width: 1.5.w,
                            height: dashHeight,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Red dot
              Container(
                width: 10.w,
                height: 10.h,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          SizedBox(width: 12.w),

          // ── Right: pickup + drop addresses ──────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AddressBlock(
                  name: "Suresh jadhav.",
                  phone: " 7214512511",
                  address: "Gujar Nimbalkar nagar, Maharashtra, Inadia",
                ),

                SizedBox(height: 16.h),

                _AddressBlock(
                  name: "Suresh jadhav.",
                  phone: " 7214512511",
                  address: "Gujar Nimbalkar nagar, Maharashtra, Inadia",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressBlock extends StatelessWidget {
  final String name;
  final String phone;
  final String address;

  const _AddressBlock({
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            children: [
              TextSpan(text: name),
              TextSpan(
                text: phone,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          address,
          style: TextStyle(fontSize: 11.sp, color: Colors.black45),
        ),
      ],
    );
  }
}