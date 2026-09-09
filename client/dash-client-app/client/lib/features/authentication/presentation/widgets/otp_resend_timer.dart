// ignore_for_file: unnecessary_underscores

import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class OtpResendTimer extends StatelessWidget {
  final ValueNotifier<bool> canResend;
  final ValueNotifier<int> resendSecs;
  final bool isLoading;
  final VoidCallback onResend;

  const OtpResendTimer({
    super.key,
    required this.canResend,
    required this.resendSecs,
    required this.isLoading,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: canResend,
      builder: (_, can, __) {
        return GestureDetector(
          onTap: can && !isLoading ? onResend : null,
          child: ValueListenableBuilder<int>(
            valueListenable: resendSecs,
            builder: (_, secs, __) {
              final label = can
                  ? 'Resend code by SMS'
                  : 'Resend code by SMS (0:${secs.toString().padLeft(2, '0')})';
              return Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: can ? AppColors.lemon : Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        );
      },
    );
  }
}