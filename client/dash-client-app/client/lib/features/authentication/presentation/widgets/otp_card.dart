import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/authentication/presentation/widgets/otp_input_row.dart';
import 'package:dash_logistics/features/authentication/presentation/widgets/otp_resend_timer.dart';
import 'package:dash_logistics/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class OtpCard extends StatefulWidget {
  final String phoneNumber;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> focusNodes;
  final ValueNotifier<int> resendSecs;
  final ValueNotifier<bool> canResend;
  final bool isLoading;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onChangeNumber; // ✅ new

  const OtpCard({
    super.key,
    required this.phoneNumber,
    required this.otpControllers,
    required this.focusNodes,
    required this.resendSecs,
    required this.canResend,
    required this.isLoading,
    required this.onVerify,
    required this.onResend,
    required this.onChangeNumber,
  });

  @override
  State<OtpCard> createState() => _OtpCardState();
}

class _OtpCardState extends State<OtpCard> {
  @override
  Widget build(BuildContext context) {
    final cardH = MediaQuery.of(context).size.height - 261.h;
    final l10n=AppLocalizations.of(context);

    return SizedBox(
      height: cardH,
      child: Padding(
        padding: EdgeInsets.fromLTRB(28.w, 36.h, 28.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Heading ───────────────────────────────────────
            Text(
              l10n.otp_title(widget.phoneNumber),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            SizedBox(height: 8.h),

            // ✅ "Changed your mobile number?" calls onChangeNumber
            // which resets auth state before popping
            GestureDetector(
              onTap: widget.onChangeNumber,
              child: Text(
                l10n.otp_change_number,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.lemon,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // ── 6 OTP boxes ───────────────────────────────────
            OtpInputRow(
              controllers: widget.otpControllers,
              focusNodes:  widget.focusNodes,
            ),
            SizedBox(height: 20.h),

            // ── Resend timer ──────────────────────────────────
            OtpResendTimer(
              canResend:  widget.canResend,
              resendSecs: widget.resendSecs,
              isLoading:  widget.isLoading,
              onResend:   widget.onResend,
            ),

            const Spacer(),

            // ── Next button ───────────────────────────────────
            _NextButton(isLoading: widget.isLoading, onVerify: widget.onVerify),
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onVerify;
  const _NextButton({required this.isLoading, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lemon,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        onPressed: isLoading ? null : onVerify,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            : Text(
                'Next',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}