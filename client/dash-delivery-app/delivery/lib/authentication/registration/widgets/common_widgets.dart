import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:delivary_partner/core/extentions/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// ─────────────────────────────────────────────
// GREEN CTA BUTTON
// ─────────────────────────────────────────────
class GreenButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? prefixIcon;

  const GreenButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedOpacity(
        opacity: onTap == null && !isLoading ? 0.55 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
           color: AppColors.commonButton,
            borderRadius: BorderRadius.circular(26.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// OUTLINE BUTTON (secondary)
// ─────────────────────────────────────────────
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Color? borderColor;
  final Color? textColor;

  const OutlineButton({
    super.key,
    required this.label,
    this.onTap,
    this.prefixIcon,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = borderColor ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 6.w)],
            Text(
              label,
              style: TextStyle(
                color: textColor ?? color,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STYLED TEXT FIELD
// ─────────────────────────────────────────────
class StyledTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final VoidCallback? onTap;

  const StyledTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters,
    this.suffix,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 54.h,
        width: 321.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
      
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4), // ← only downward (bottom shadow)
              spreadRadius: 0,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          readOnly: readOnly,
          onTap: onTap,
          style: context.headlineMediumOne.copyWith(fontSize: 18.sp, color: Color.fromRGBO(169, 169, 169, 1),
          fontWeight: FontWeight.w400,),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textLight),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: InputBorder.none,
            counterText: '',
            suffixIcon: suffix,
          ),
        ),
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.errorRed, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 12.sp, color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }
}


