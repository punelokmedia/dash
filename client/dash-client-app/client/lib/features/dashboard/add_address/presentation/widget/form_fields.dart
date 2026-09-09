import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// ── Single underline field ────────────────────────────────────────────────────
class AddressField extends StatelessWidget {
  final TextEditingController     ctrl;
  final String                    hint;
  final TextInputType?            keyboardType;
  final List<TextInputFormatter>? formatters;
  final bool                      optional;

  const AddressField({
    super.key,
    required this.ctrl,
    required this.hint,
    this.keyboardType,
    this.formatters,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:      ctrl,
      keyboardType:    keyboardType,
      inputFormatters: formatters,
      style: TextStyle(
        fontSize:   14.sp,
        color:      Colors.black87,
        fontFamily: AppTextStyles.fontFamilyRoboto,
      ),
      decoration: InputDecoration(
        hintText:  optional ? '$hint (optional)' : hint,
        hintStyle: TextStyle(
          fontSize:   14.sp,
          color:      Colors.grey.shade400,
          fontFamily: AppTextStyles.fontFamilyRoboto,
        ),
        isDense:        true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8BAF00), width: 1.5),
        ),
      ),
    );
  }
}

// ── Side-by-side lat/lng row ──────────────────────────────────────────────────
class LatLngRow extends StatelessWidget {
  final TextEditingController latCtrl;
  final TextEditingController lngCtrl;

  const LatLngRow({
    super.key,
    required this.latCtrl,
    required this.lngCtrl,
  });

  @override
  Widget build(BuildContext context) {
    const numType = TextInputType.numberWithOptions(decimal: true, signed: true);
    return Row(
      children: [
        Expanded(
          child: AddressField(ctrl: latCtrl, hint: 'Latitude',  keyboardType: numType),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AddressField(ctrl: lngCtrl, hint: 'Longitude', keyboardType: numType),
        ),
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class FormSection extends StatelessWidget {
  final String title;
  const FormSection(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize:      11.sp,
            fontWeight:    FontWeight.w700,
            color:         Colors.grey.shade500,
            letterSpacing: 0.8,
            fontFamily:    AppTextStyles.fontFamilyRoboto,
          ),
        ),
      );
}