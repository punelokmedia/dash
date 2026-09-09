// ignore_for_file: unnecessary_underscores, depend_on_referenced_packages

import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/utils/snackbar_helper.dart';
import 'package:dash_logistics/features/dashboard/add_gst/presentation/widgets/gst_confirm_button.dart';
import 'package:dash_logistics/features/dashboard/add_gst/presentation/widgets/gst_textfield.dart';
import 'package:dash_logistics/features/dashboard/add_gst/shared/gstin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';



class AddGstinScreen extends HookConsumerWidget {
  const AddGstinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gstinController = useTextEditingController();
    final gstinState = ref.watch(gstinControllerProvider);
    final controller = ref.read(gstinControllerProvider.notifier);

    // Navigate on success
    ref.listen(gstinControllerProvider, (previous, next) {
      if (next.isSuccess && !(previous?.isSuccess ?? false)) {
        // Show success snackbar
        SnackbarHelper.showSuccess(context, next.gstinData?.message ?? 'GSTIN added successfully!');
        context.go('/home'); // or context.pop() if pushed on stack
      }
    });

    void handleSubmit() {
      controller.clearError();
      controller.submitGstin(gstinController.text);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.lemon,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 30.sp, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add GSTIN',
          style: TextStyle(
            color:AppColors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Card container
              SizedBox(height: 45.h,),
              Container(
                width: 154.w,
                height: 154.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/Icons/profile/gstIcon.png',
                    width: 88.w,
                    height: 88.h,
                    // Fallback if asset not found
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.receipt_long_outlined,
                      size: 88.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
                            
              SizedBox(height: 10.h),
                            
              // Title
              Text(
                'Add GSTIN',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  color:AppColors.black,
                ),
              ),
                            
              SizedBox(height: 8.h),
                            
              // Subtitle
              Text(
                'Enter GSTIN to get proper tax invoices\nand enjoy Input Tax Credit benefits.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: "Roboto",
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
                            
              SizedBox(height: 25.h),
                            
              // GSTIN TextField
              GstinTextField(
                controller: gstinController,
                errorText: gstinState.errorMessage,
                onChanged: controller.clearError,
              ),
                            
              Spacer(),
                            
              // Confirm button
              GstinConfirmButton(
                isLoading: gstinState.isLoading,
                onPressed: handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}