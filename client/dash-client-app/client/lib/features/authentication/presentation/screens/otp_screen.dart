// ignore_for_file: deprecated_member_use, use_build_context_synchronously, curly_braces_in_flow_control_structures, depend_on_referenced_packages

import 'dart:async';

import 'package:dash_logistics/core/animation/animation.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/utils/snackbar_helper.dart';
import 'package:dash_logistics/features/authentication/domain/models/auth_state.dart';
import 'package:dash_logistics/features/authentication/infra/auth_controller.dart';
import 'package:dash_logistics/features/authentication/presentation/widgets/otp_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



class OtpPage extends HookConsumerWidget {
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpControllers = List.generate(6, (_) => useTextEditingController());
    final focusNodes     = List.generate(6, (_) => useFocusNode());
    final state          = ref.watch(authControllerProvider);
    final resendSecs     = useState(30);
    final canResend      = useState(false);
    final timerRef       = useRef<Timer?>(null);
    


    final animCtrl = useAnimationController(
      duration: const Duration(seconds: 2),
    );
    final anims = useMemoized(() => RegisterPageAnimations(animCtrl), [
      animCtrl,
    ]);
    useEffect(() {
      animCtrl.forward();
      return null;
    }, []);

    // ── Countdown ─────────────────────────────────────────────
    void startCountdown() {
      timerRef.value?.cancel();
      resendSecs.value = 30;
      canResend.value  = false;
      timerRef.value   = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!context.mounted) { t.cancel(); return; }
        if (resendSecs.value > 0) {
          resendSecs.value--;
        } else {
          canResend.value = true;
          t.cancel();
        }
      });
    }

    useEffect(() {
      startCountdown();
      return () => timerRef.value?.cancel();
    }, []);

    void goBack() {
      timerRef.value?.cancel();
      ref.read(authControllerProvider.notifier).reset();
      context.pop();
    }

    // ── Auth listener ─────────────────────────────────────────
    ref.listen<AsyncValue<AuthState>>(authControllerProvider, (_, next) {
      if (next is AsyncError) {
        
        SnackbarHelper.showError(context, next.error.toString());
      }
      next.whenOrNull(data: (data) {
        if (!data.isLoggedIn) return;
        if (data.profileCompleted) {
          SnackbarHelper.showSuccess(
            context, 
            "Login successful",
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) context.goNamed(AppRoutesName.homePageName);
          });
        } else {
          Future.delayed(const Duration(milliseconds: 200), () {
            if (context.mounted) context.goNamed(AppRoutesName.registerPageName);
          });
        }
      });
    });

    // ── Verify ────────────────────────────────────────────────
    Future<void> handleVerify() async {
      final otp = otpControllers.map((c) => c.text).join();
      if (otp.length < 6) {
        SnackbarHelper.showWarning(context, 'Please enter the 6-digit OTP');
        return;
      }
      await ref.read(authControllerProvider.notifier).verifyOtp(
            phone: phoneNumber,
            otp: otp,
          );
    }

    // ── Resend ────────────────────────────────────────────────
    Future<void> handleResend() async {
      try {
        for (final c in otpControllers) c.clear();
        focusNodes[0].requestFocus();
        await ref.read(authControllerProvider.notifier).sendOtp(phoneNumber);
        startCountdown();
      } catch (e) {
        SnackbarHelper.showWarning(context, e.toString());
      }
    }

    return Scaffold(
      backgroundColor: AppColors.lemon,
      body: Column(
        children: [
          // ── GREEN HEADER (back button + logo + truck) ─────────
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16.h),
                    // Logo
                    // SlideTransition(
                    //   position: anims.logoAnimation,
                    //   child: Image.asset(
                    //     "assets/Images/login.png",
                    //     height: 68.h,
                    //     width: 170.w,
                    //   ),
                    // ),
                    SizedBox(height: 119.h),
                    // Truck flush against white card
                    // SlideTransition(
                    //   position: anims.truckAnimation,
                    //   child: AnimatedTruckOnCurve(height: 105.h)
                    // ),
                  ],
                ),

                // Back button overlaid top-left
                Positioned(
                  top: 8.h,
                  left: 16.w,
                  child: GestureDetector(
                    onTap: goBack,
                    child: Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── WHITE CARD — fills remaining space, zero gap ──────
          Expanded(
            child: SlideTransition(
              position: anims.cardAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r),topRight: Radius.circular(40.r)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18000000),
                      blurRadius: 4,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: OtpCard(
                  phoneNumber:    phoneNumber,
                  otpControllers: otpControllers,
                  focusNodes:     focusNodes,
                  resendSecs:     resendSecs,
                  canResend:      canResend,
                  isLoading:      state.isLoading,
                  onVerify:       handleVerify,
                  onResend:       handleResend,
                  onChangeNumber: goBack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}