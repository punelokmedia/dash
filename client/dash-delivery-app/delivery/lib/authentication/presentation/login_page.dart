import 'dart:async';

import 'package:delivary_partner/authentication/infra/authcontroller.dart';
import 'package:delivary_partner/authentication/registration/domain/registration_step.dart';
import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
import 'package:delivary_partner/authentication/shared/authprovider.dart';
import 'package:delivary_partner/core/extentions/text_style.dart';
import 'package:delivary_partner/core/extentions/toast_extention.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // ── Controllers & State ───────────────────────────────────────────────────
    final phoneController = useTextEditingController();
    final otpController = useTextEditingController();
    final authState = ref.watch(authControllerProvider);

    final isPhoneValid = useState(false);
    final hasText = useState(false);
    final otpSent = useState(false);
    final isOtpComplete = useState(false);

    final seconds = useState(30);
    final timerRef = useRef<Timer?>(null);

    // ── Phone validation ──────────────────────────────────────────────────────
    useEffect(() {
      void listener() {
        final text = phoneController.text.trim();
        isPhoneValid.value = RegExp(r'^[6-9]\d{9}$').hasMatch(text);
        hasText.value = phoneController.text.isNotEmpty;
      }

      phoneController.addListener(listener);
      return () => phoneController.removeListener(listener);
    }, [phoneController]);

    // Cancel timer on dispose
    useEffect(() {
      return () {
        timerRef.value?.cancel();
        timerRef.value = null;
      };
    }, const []);

    // ── Resend countdown ──────────────────────────────────────────────────────
    void startTimer() {
      timerRef.value?.cancel();
      seconds.value = 30;
      timerRef.value = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!t.isActive) return;
        if (seconds.value <= 1) {
          t.cancel();
          timerRef.value = null;
          seconds.value = 0;
        } else {
          seconds.value--;
        }
      });
    }

    // ── Auth state listener ───────────────────────────────────────────────────
    ref.listen<AsyncValue<AuthStatus>>(authControllerProvider, (
      previous,
      next,
    ) {
      if (next.isLoading) return;

      next.when(
        loading: () {},

        data: (status) async {
          // ── OTP sent ──────────────────────────────────────────────────────
          if (status == AuthStatus.otpSent) {
            // Prevent duplicate toast on rebuilds
            if (previous?.isLoading != true) return;
            otpSent.value = true;
            startTimer();
            context.successToast('OTP sent successfully', Colors.green);
          }

          // ── OTP verified ──────────────────────────────────────────────────
          if (status == AuthStatus.verified) {
            // 1. Persist the phone number
            await ref
                .read(registrationProgressProvider.notifier)
                .savePhone(phoneController.text.trim());

            // 2. Save the auth token returned by your API
            //    (assuming SecureStorageService.saveToken is already called
            //     inside authcontroller.verifyOtp — if not, add it there)

            // 3. Check if this user has already started registration.
            //    The router redirect will automatically send them to the
            //    correct step, but we need to make sure the step is at
            //    least "kyc" so the redirect knows they're logged in.
            final currentStep = ref.read(registrationProgressProvider).step;

            if (currentStep == RegistrationStep.notStarted) {
              // Brand-new user — start from KYC documents
              await ref
                  .read(registrationProgressProvider.notifier)
                  .advance(RegistrationStep.kyc);
              //                 Navigator.push(
              // context,
              // MaterialPageRoute(builder: (_) => const TrainingTutorialPage(videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',)),);
            }

            // If step > notStarted, the router redirect will resume them
            // at exactly where they left off. No manual goNamed needed.
          }
        },

        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getErrorMessage(e)),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 150,
                left: 16,
                right: 16,
              ),
            ),
          );
        },
      );
    });

    // ── UI ────────────────────────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: const Color(0xFF8DC63F),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Logo ─────────────────────────────────────────────────────
            SizedBox(height: 32.h),
            Image.asset(
              'assets/images/png/dash_logo.png',
              height: 80.h,
              width: 220.w,
              fit: BoxFit.contain,
            ),

            // ── White card ────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 0.h),

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),

                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Title ───────────────────────────────────────────────
                        SizedBox(height: 20.h),
                        Center(
                          child: Text(
                            'Login',
                            style: context.headlineMedium.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(20, 174, 92, 1),
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // ── Phone field ─────────────────────────────────────────
                        Container(
                          height: 52.h,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromRGBO(169, 169, 169, 1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '+91',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Mobile number',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 15.sp,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                  ),
                                ),
                              ),
                              // ── Get OTP pill ──────────────────────────────────
                              GestureDetector(
                                onTap: isPhoneValid.value && !otpSent.value
                                    ? () => ref
                                          .read(authControllerProvider.notifier)
                                          .requestOtp(phoneController.text)
                                    : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 7.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPhoneValid.value
                                        ? const Color(0xFFFFD580)
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    'Get OTP',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isPhoneValid.value
                                          ? Colors.black
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Validation error ──────────────────────────────────────
                        if (hasText.value && !isPhoneValid.value)
                          Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: Text(
                              phoneController.text.trim().length == 10
                                  ? 'Number must start with 6, 7, 8, or 9'
                                  : 'Enter a valid 10-digit mobile number',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),

                        SizedBox(height: 24.h),

                        // ── OTP field ─────────────────────────────────────────────
                        OtpInputField(
                          otpSent: otpSent.value,
                          otpController: otpController,
                          onChanged: (_) {
                            isOtpComplete.value =
                                otpController.text.length == 6;
                          },
                          onCompleted: (_) {
                            isOtpComplete.value = true;
                          },
                        ),

                        SizedBox(height: 16.h),

                        // ── Resend OTP ────────────────────────────────────────────
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: otpSent.value && seconds.value == 0
                                ? () async {
                                    await ref
                                        .read(authControllerProvider.notifier)
                                        .requestOtp(phoneController.text);
                                    startTimer();
                                  }
                                : null,
                            child: Text(
                              otpSent.value && seconds.value > 0
                                  ? 'Resend OTP in ${seconds.value}s'
                                  : 'Resend OTP ?',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: otpSent.value && seconds.value == 0
                                    ? const Color.fromRGBO(251, 172, 44, 0.84)
                                    : const Color(0xFFFF9800).withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // ── Submit button ─────────────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                129,
                                196,
                                93,
                                1,
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            onPressed: isOtpComplete.value
                                ? () => ref
                                      .read(authControllerProvider.notifier)
                                      .verifyOtp(
                                        phoneController.text,
                                        otpController.text,
                                      )
                                : null,
                            child: authState.isLoading
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Register Now',
                                    style: context.headlineMediumOne.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // ── Illustration ──────────────────────────────────────────
                        Center(
                          child: Image.asset(
                            'assets/images/png/truck.png',
                            fit: BoxFit.contain,
                            height: 170.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── OTP Input Widget ──────────────────────────────────────────────────────────
class OtpInputField extends StatelessWidget {
  final bool otpSent;
  final TextEditingController otpController;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputField({
    super.key,
    required this.otpSent,
    required this.otpController,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 58.w;
    final innerPadding = 40.w;
    final totalGaps = 5 * 12.0;
    final usableWidth = screenWidth - horizontalPadding - innerPadding;
    final boxWidth = (usableWidth - totalGaps) / 6;

    final defaultTheme = PinTheme(
      width: boxWidth,
      height: 40.h,
      textStyle: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(243, 243, 243, 1),
        border: Border(
          bottom: BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: SizedBox(
        height: 52.h,
        child: !otpSent
            // ── Placeholder dashes ────────────────────────────────────────────
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OTP',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color.fromRGBO(169, 169, 169, 1),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: List.generate(
                      6,
                      (i) => Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: i < 5 ? 10 : 0),
                          height: 1,
                          color: const Color.fromRGBO(169, 169, 169, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            // ── Active Pinput ─────────────────────────────────────────────────
            : Align(
                alignment: Alignment.center,
                child: Pinput(
                  controller: otpController,
                  length: 6,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  closeKeyboardWhenCompleted: true,
                  defaultPinTheme: defaultTheme,
                  focusedPinTheme: defaultTheme.copyWith(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(243, 243, 243, 1),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF0DC365), width: 2),
                      ),
                    ),
                  ),
                  submittedPinTheme: defaultTheme.copyWith(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(243, 243, 243, 1),
                      border: Border(
                        bottom: BorderSide(color: Colors.black54, width: 1.5),
                      ),
                    ),
                  ),
                  errorPinTheme: defaultTheme.copyWith(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(243, 243, 243, 1),
                      border: Border(
                        bottom: BorderSide(color: Colors.redAccent, width: 2),
                      ),
                    ),
                  ),
                  separatorBuilder: (_) => const SizedBox(width: 10),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  onCompleted: onCompleted,
                  onChanged: onChanged,
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 1.5,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0DC365),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// ── Error message helper ──────────────────────────────────────────────────────
String _getErrorMessage(Object e) {
  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Server is not responding. Please check your connection.';
      case DioExceptionType.connectionError:
        return 'Cannot reach the server. Check your network.';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode}). Try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
  return 'Unexpected error. Please try again.';
}
