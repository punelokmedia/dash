import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:delivary_partner/core/routes/app_routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/common_widgets.dart';

class ProcessCompletedScreen extends HookConsumerWidget {
  const ProcessCompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = MediaQuery.of(context).padding.top;

    // ── Controllers ──────────────────────────────────────────
    // Bug fix: store controller so it's not re-created on rebuild
    final animCtrl = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );

    // Ripple ring pulse (loops)
    final rippleCtrl = useAnimationController(
      duration: const Duration(milliseconds: 1800),
    );

    // Confetti drift (loops)
    final confettiCtrl = useAnimationController(
      duration: const Duration(milliseconds: 2400),
    );

    useEffect(() {
      // Staggered start
      animCtrl.forward();
      Future.delayed(const Duration(milliseconds: 600), () {
        rippleCtrl.repeat();
        confettiCtrl.repeat();
      });
      return () {
        // Bug fix: properly dispose all controllers via hooks — nothing extra needed
        // flutter_hooks disposes automatically, but we stop loops cleanly
        rippleCtrl.stop();
        confettiCtrl.stop();
      };
    }, const []);

    // ── Animations ───────────────────────────────────────────
    final checkScale = CurvedAnimation(
      parent: animCtrl,
      curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
    );
    final titleFade = CurvedAnimation(
      parent: animCtrl,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
    );
    final titleSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animCtrl,
            curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
          ),
        );
    final subtitleFade = CurvedAnimation(
      parent: animCtrl,
      curve: const Interval(0.60, 0.85, curve: Curves.easeOut),
    );
    final btnFade = CurvedAnimation(
      parent: animCtrl,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
    );
    final rippleScale = Tween<double>(
      begin: 1.0,
      end: 2.2,
    ).animate(CurvedAnimation(parent: rippleCtrl, curve: Curves.easeOut));
    final rippleOpacity = Tween<double>(
      begin: 0.35,
      end: 0.0,
    ).animate(CurvedAnimation(parent: rippleCtrl, curve: Curves.easeOut));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.ScaffoldBackground,
        body: Stack(
          children: [
            // ── Layer 1: Background image ─────────────────────

            // ── Layer 2: Logo + Screen title ──────────────────
            Positioned(
              top: topPadding + 70.h,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    'Process Completed',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.commonText,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            // ── Layer 3: Main content ─────────────────────────
            Positioned(
              top: 26.h + topPadding,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // ── Animated check + ripple rings ─────────
                    AnimatedBuilder(
                      animation: Listenable.merge([rippleScale, checkScale]),
                      builder: (context, _) {
                        return SizedBox(
                          width: 160.w,
                          height: 160.w,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ripple ring
                              Transform.scale(
                                scale: rippleScale.value,
                                child: Opacity(
                                  opacity: rippleOpacity.value,
                                  child: Container(
                                    width: 110.w,
                                    height: 110.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Soft glow ring
                              Container(
                                width: 120.w,
                                height: 120.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withOpacity(0.08),
                                ),
                              ),

                              // Check circle (scales in)
                              ScaleTransition(
                                scale: checkScale,
                                child: Container(
                                  width: 100.w,
                                  height: 100.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primary.withGreen(180),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 24,
                                        spreadRadius: 4,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 48.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 36.h),

                    // ── Title ─────────────────────────────────
                    FadeTransition(
                      opacity: titleFade,
                      child: SlideTransition(
                        position: titleSlide,
                        child: Text(
                          'Process\nCompleted',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ── Welcome + subtitle ────────────────────
                    FadeTransition(
                      opacity: subtitleFade,
                      child: Column(
                        children: [
                          Text(
                            'Welcome to Dash !!',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Your account is ready. Anything, Anywhere —\nnow just a tap away.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textMedium,
                              height: 1.65,
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // ── NEW: 3 feature chips ──────────────
                          _FeatureChipsRow(),
                        ],
                      ),
                    ),

                    const Spacer(flex: 2),

                    // ── Proceed button ────────────────────────
                    FadeTransition(
                      opacity: btnFade,
                      child: GreenButton(
                        label: 'Go to Dashboard',
                        onTap: () {
                          context.go(AppRoutesName.homePageName);
                        },
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NEW: Feature chips row (shown after completion)
// ─────────────────────────────────────────────
class _FeatureChipsRow extends StatelessWidget {
  static const _chips = [
    (icon: Icons.flash_on_rounded, label: 'Fast Delivery'),
    (icon: Icons.location_on_rounded, label: 'Live Tracking'),
    (icon: Icons.payments_rounded, label: 'Easy Payouts'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _chips.map((chip) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(chip.icon, size: 14.sp, color: AppColors.primary),
              SizedBox(width: 4.w),
              Text(
                chip.label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
