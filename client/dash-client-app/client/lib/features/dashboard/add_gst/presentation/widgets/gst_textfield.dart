import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class GstinTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final VoidCallback? onChanged;

  const GstinTextField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        maxLength: 15,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        ],
        onChanged: (_) => onChanged?.call(),
        decoration: InputDecoration(
          hintText: 'GSTIN',
          hintStyle: TextStyle(color: Color.fromRGBO(180,176,176,1), fontSize: 18.sp,fontWeight: FontWeight.w600,fontFamily: 'Roboto'),
          counterText: '',
          errorText: errorText,
          contentPadding:EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.lemon, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
          filled: true,
          fillColor: Color.fromRGBO(237,237,237,1),
        ),
      ),
    );
  }
}