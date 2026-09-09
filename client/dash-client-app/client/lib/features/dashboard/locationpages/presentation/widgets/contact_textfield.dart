import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


// ── Underline-only text field ─────────────────────────────────────────────────
class UnderlineField extends StatelessWidget {
  final String       hintText;
  final String?      initialValue;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String>? validator;
 
  const UnderlineField({super.key, 
    required this.hintText,
    required this.onChanged,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.validator,
  });
 
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged:    onChanged,
      keyboardType: keyboardType,
      inputFormatters: [
        ...inputFormatters,
      ],
      validator: validator,
      style: TextStyle(
        fontSize:   14.sp,
        color:      Colors.black87,
        fontFamily: AppTextStyles.fontFamilyRoboto,
      ),
      decoration: InputDecoration(
        hintText:  hintText,
        hintStyle: TextStyle(
          fontSize:   13.sp,
          color:      Colors.grey.shade400,
          fontFamily: AppTextStyles.fontFamilyRoboto,
        ),
        // ✅ Underline only — no box border
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lemon, width: 1.5),
        ),
        isDense:        true,
        contentPadding: EdgeInsets.only(bottom: 8.h),
      ),
    );
  }
}
 


 
// ── Save as chip ──────────────────────────────────────────────────────────────
class SaveChip extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final bool         isSelected;
  final VoidCallback onTap;
 
  const SaveChip({super.key, 
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:        isSelected ? AppColors.lemon.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.lemon : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size:  14.sp,
              color: isSelected ? AppColors.lemon : Colors.black54,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize:   13.sp,
                color:      isSelected ? AppColors.lemon : Colors.black87,
                fontFamily: AppTextStyles.fontFamilyRoboto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}