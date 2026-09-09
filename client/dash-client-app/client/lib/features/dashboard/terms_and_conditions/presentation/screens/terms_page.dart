import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/terms_header.dart';
import '../widgets/setting_tile.dart';

class TermsPage extends HookConsumerWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.lemon,
      body: Column(
        children: [
          /// HEADER
          const TermsHeader(),

          /// WHITE SECTION
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                // borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Column(
                children: const [
                  SettingsTile(title: "Terms and Conditions"),

                  SettingsTile(title: "Privacy Policy"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
