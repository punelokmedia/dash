// ignore: unused_import
// ignore_for_file: depend_on_referenced_packages, duplicate_ignore, unused_import

import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/dashboard/help_support/presentation/widgets/support_header.dart';
import 'package:dash_logistics/features/dashboard/help_support/presentation/widgets/support_tile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HelpSupportPage extends HookConsumerWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(                      // ✅ removed SafeArea — header handles top inset itself
        children: [

          /// HEADER
          const SupportHeader(),

          /// WHITE CARD
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -1),
                    blurRadius: 4.sp,
                    color: const Color.fromRGBO(0, 0, 0, 0.16),
                  )
                ],
              ),
              child: ListView(
                children: [

                  SizedBox(height: 20.h),

                  SupportTile(
                    title:    'Manage my bookings',
                    subtitle: 'View, reschedule, or cancel existing booking',
                    onTap:    () {},
                  ),

                  SupportTile(
                    title:    'Check payment history',
                    subtitle: 'Access past transactions & receipts',
                    onTap:    () {},
                  ),

                  SupportTile(
                    title:    'Track my delivery',
                    subtitle: 'Get real-time updates on delivery status',
                    onTap:    () {},
                  ),

                  SupportTile(
                    title:    'Contact customer support',
                    subtitle: 'Reach out for personalized assistance',
                    onTap:    () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}