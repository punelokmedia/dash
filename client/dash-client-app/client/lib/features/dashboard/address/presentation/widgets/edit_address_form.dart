import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/features/dashboard/address/domain/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class EditAddressForm extends StatelessWidget {
  final GlobalKey<FormState>  formKey;
  final TextEditingController nameCtrl, phoneCtrl, houseCtrl, pinCtrl;
  final AddressModel          address;
  final bool                  isLoading;
  final VoidCallback          onSave;

  const EditAddressForm({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.houseCtrl,
    required this.pinCtrl,
    required this.address,
    required this.isLoading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            _EditField(
              controller: nameCtrl,
              hint: 'Full Name',
              validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
            ),
            SizedBox(height: 12.h),

            _EditField(
              controller: phoneCtrl,
              hint: 'Mobile Number',
              keyboardType: TextInputType.phone,
              suffix: TextButton(
                onPressed: () {},
                child: Text('Change', style: TextStyle(fontSize: 13.sp, color: AppColors.lemon)),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Enter phone' : null,
            ),
            SizedBox(height: 12.h),

            _EditField(
              controller: houseCtrl,
              hint: 'House / Apartment / Shop (optional)',
            ),
            SizedBox(height: 12.h),

            _EditField(
              controller: pinCtrl,
              hint: 'Pincode (optional)',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8.h),

            _UseMobileRow(phoneCtrl: phoneCtrl),
            SizedBox(height: 16.h),

            SizedBox(
              width: double.infinity,
              height: 58.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonLemon,
                  shape: const StadiumBorder(),
                  elevation: 2,
                ),
                onPressed: isLoading ? null : onSave,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : Text('Save', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.white,fontFamily: AppTextStyles.fontFamilyInter)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final TextEditingController      controller;
  final String                     hint;
  final TextInputType              keyboardType;
  final Widget?                    suffix;
  final String? Function(String?)? validator;

  const _EditField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:   controller,
      keyboardType: keyboardType,
      validator:    validator,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText:  hint,
        hintStyle: TextStyle(color: Colors.black38, fontSize: 14.sp),
        suffixIcon: suffix,
        filled:    true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.lemon, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      ),
    );
  }
}

class _UseMobileRow extends StatefulWidget {
  final TextEditingController phoneCtrl;
  const _UseMobileRow({required this.phoneCtrl});

  @override
  State<_UseMobileRow> createState() => _UseMobileRowState();
}

class _UseMobileRowState extends State<_UseMobileRow> {
  bool _checked = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _checked,
          activeColor: AppColors.lemon,
          onChanged: (v) => setState(() => _checked = v ?? false),
        ),
        Text(
          'Use my mobile number : ${widget.phoneCtrl.text}',
          style: TextStyle(fontSize: 13.sp, color: Colors.black54),
        ),
      ],
    );
  }
}