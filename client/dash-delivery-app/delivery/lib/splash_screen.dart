import 'package:delivary_partner/authentication/registration/domain/registration_step.dart';
import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
import 'package:delivary_partner/core/extentions/text_style.dart';
import 'package:delivary_partner/core/infra/secured_storage.dart';
import 'package:delivary_partner/core/routes/app_routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

enum SplashStatus { loading, login, resume, home }

class SplashNotifier extends StateNotifier<SplashStatus> {
  SplashNotifier() : super(SplashStatus.loading);

  Future<void> initialize(RegistrationStep savedStep) async {
    // Minimum splash duration + auth check run in parallel
    final results = await Future.wait([
      Future.delayed(const Duration(milliseconds: 4800)),
      _checkAuth(),
    ]);

    final isLoggedIn = results[1] as bool;

    if (!isLoggedIn) {
      // No token → go to login
      state = SplashStatus.login;
      return;
    }

    // Logged in — decide where to send user
    if (savedStep == RegistrationStep.completed) {
      state = SplashStatus.home;
    } else {
      // Registration in progress — router redirect will handle exact step
      state = SplashStatus.resume;
    }
  }

  Future<bool> _checkAuth() async {
    final token = await SecureStorageService.getToken();
    return token != null && token.isNotEmpty;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

final splashProvider = StateNotifierProvider<SplashNotifier, SplashStatus>((
  ref,
) {
  return SplashNotifier();
});

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoOpacity = useState(0.0);
    final logoScale = useState(0.75);
    final taglineOpacity = useState(0.0);
    final partnerOpacity = useState(0.0);

    final splashStatus = ref.watch(splashProvider);

    // ── Start initialize once on mount ────────────────────────────────────
    useEffect(() {
      // Read the persisted registration step synchronously from SharedPreferences
      // (already loaded before runApp — so this is instant)
      final savedStep = ref.read(registrationProgressProvider).step;
      ref.read(splashProvider.notifier).initialize(savedStep);
      return null;
    }, const []);

    // ── Staggered entrance animations ─────────────────────────────────────
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 200), () {
        logoOpacity.value = 1.0;
        logoScale.value = 1.0;
      });
      Future.delayed(const Duration(milliseconds: 700), () {
        taglineOpacity.value = 1.0;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        partnerOpacity.value = 1.0;
      });
      return null;
    }, const []);

    // ── Navigate when splash finishes ─────────────────────────────────────
    useEffect(() {
      switch (splashStatus) {
        case SplashStatus.home:
          // Registration complete → go straight to home
          Future.microtask(() => context.goNamed(AppRoutesName.homePageName));
          break;

        case SplashStatus.login:
          // Not logged in → go to login
          Future.microtask(() => context.goNamed(AppRoutesName.loginPageName));
          break;

        case SplashStatus.resume:
          // Logged in but registration incomplete →
          // GoRouter redirect() will pick the correct step automatically.
          // We just need to leave the splash; going to login triggers redirect.
          Future.microtask(() => context.goNamed(AppRoutesName.loginPageName));
          break;

        case SplashStatus.loading:
          // Still loading — do nothing
          break;
      }
      return null;
    }, [splashStatus]);

    // ── UI ────────────────────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Logo ─────────────────────────────────────────────
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 550),
                    opacity: logoOpacity.value,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 550),
                      curve: Curves.easeOutBack,
                      scale: logoScale.value,
                      child: Image.asset(
                        'assets/images/png/Group_dash.png',
                        height: 158.h,
                        width: 191.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  // ── "Partner" text ────────────────────────────────────
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: partnerOpacity.value,
                    child: Text(
                      'Partner',
                      style: context.headlineMedium.copyWith(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Loading spinner ───────────────────────────────────────────
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: taglineOpacity.value,
                child: Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF088913),
                      ),
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
