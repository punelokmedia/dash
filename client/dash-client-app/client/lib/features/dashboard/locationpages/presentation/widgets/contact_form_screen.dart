import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/core/utils/snackbar_helper.dart';
import 'package:dash_logistics/features/dashboard/locationpages/infra/contact_controller.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/contact_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContactFormScreen extends HookConsumerWidget {
  const ContactFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(contactControllerProvider);
    final controller = ref.read(contactControllerProvider.notifier);

    // ✅ useRef holds the GlobalKey across rebuilds without StatefulWidget
    final formKey = useRef(GlobalKey<FormState>()).value;

    // ✅ Listen for success / error → show snackbar
    ref.listen(contactControllerProvider, (_, next) {
      if (next.successMessage != null) {
        SnackbarHelper.showSuccess(context, next.successMessage!);
        controller.clearSuccess();
      }
      if (next.errorMessage != null) {
        SnackbarHelper.showError(context, next.errorMessage!);
        controller.clearError();
      }
    });

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name ────────────────────────────────────────
            UnderlineField(
              initialValue: formState.name,
              hintText: 'Full Name',
              onChanged: controller.updateName,
            ),

            SizedBox(height: 4.h),

            // ── Phone + Change ───────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: UnderlineField(
                    initialValue: formState.phone,
                    hintText: 'Phone Number',
                    onChanged: controller.updatePhone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter phone number';
                      if (v.length != 10) return 'Must be 10 digits';
                      if (!RegExp(r'^[6-9]').hasMatch(v)) {
                        return 'Enter a valid mobile number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // ── Address ──────────────────────────────────────
            UnderlineField(
              initialValue: formState.address,
              hintText: 'Change  House / Apartment / Shop (optional)',
              onChanged: controller.updateaddress,
            ),

            SizedBox(height: 4.h),

            // ── Pincode ──────────────────────────────────────
            UnderlineField(
              initialValue: formState.pincode,
              hintText: 'Pincode (optional)',
              onChanged: controller.updatePincode,
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 16.h),

            // ── Checkbox ─────────────────────────────────────
            Row(
              children: [
                SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: Checkbox(
                    value: formState.useMobile,
                    onChanged: (v) => controller.toggleMobile(v!),
                    activeColor: AppColors.lemon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'Use my mobile number : ${formState.phone.isNotEmpty ? formState.phone : ""}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black87,
                    fontFamily: AppTextStyles.fontFamilyRoboto,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // ── Save as ──────────────────────────────────────
            Text(
              'Save as (optional)',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black54,
                fontFamily: AppTextStyles.fontFamilyRoboto,
              ),
            ),

            SizedBox(height: 8.h),

            Row(
              children: [
                SaveChip(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  isSelected: formState.saveAs == 'Home',
                  onTap: () => controller.updateSaveAs('Home'),
                ),
                SizedBox(width: 10.w),
                SaveChip(
                  icon: Icons.store_outlined,
                  label: 'Shop',
                  isSelected: formState.saveAs == 'Shop',
                  onTap: () => controller.updateSaveAs('Shop'),
                ),
                SizedBox(width: 10.w),
                SaveChip(
                  icon: Icons.favorite_border_rounded,
                  label: 'Other',
                  isSelected: formState.saveAs == 'Other',
                  onTap: () => controller.updateSaveAs('Other'),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // ── Submit button ─────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: formState.isLoading
                    ? null
                    : () {
                        // ✅ formKey now defined via useRef
                        // if (formKey.currentState!.validate()) {
                        //   controller.submit();
                        // }
                        context.pushNamed(AppRoutesName.selectVehicleScreen);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lemon,
                  disabledBackgroundColor: AppColors.lemon.withValues(
                    alpha: 0.6,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: formState.isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Enter Contact Details',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: AppTextStyles.fontFamilyRoboto,
                        ),
                      ),
              ),
            ),

            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
