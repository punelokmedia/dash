import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/features/dashboard/locationpages/infra/contact_controller.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/contact_form_screen.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/map_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Contactdetails extends HookConsumerWidget {
  const Contactdetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final formState=ref.watch(contactControllerProvider);
    final controller=ref.read(contactControllerProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lemon,
        leading: Icon(
          Icons.arrow_back_ios,
          size: 20.sp,
          color: AppColors.white,
        ),
        title: Text(
          "Enter Contact Details",
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamilyInter,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const MapSection(),
          ContactFormScreen()
        ],
      ),
    );
  }
}
