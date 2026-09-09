// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ProfileMenuTile extends StatelessWidget {
  final String imagePath;       // e.g. 'assets/Icons/saved_address.png'
  final String label;
  final String? trailing;       // e.g. "0" for rewards count
  final Color? imageColor;      // optional tint on the image
  final Color? labelColor;
  final VoidCallback? onTap;
  final bool showDivider;

  const ProfileMenuTile({
    super.key,
    required this.imagePath,
    required this.label,
    this.trailing,
    this.imageColor,
    this.labelColor,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 14.h),
            child: Row(
              children: [
                // ── Image icon ───────────────────────────────
                SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    color: imageColor,          // null = original colors
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.image_not_supported_outlined,
                      size: 20.r,
                      color: Colors.black38,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),

                // ── Label ────────────────────────────────────
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: labelColor ?? Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // ── Optional trailing count ──────────────────
                if (trailing != null) ...[
                  Text(
                    trailing!,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  ),
                  SizedBox(width: 4.w),
                ],

                // ── Chevron ──────────────────────────────────
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.r,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }
}