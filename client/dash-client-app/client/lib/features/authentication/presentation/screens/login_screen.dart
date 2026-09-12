// ignore_for_file: depend_on_referenced_packages

import 'package:dash_logistics/core/animation/animation.dart';
import 'package:dash_logistics/core/network/dev_auth.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';


import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/utils/snackbar_helper.dart';

import 'package:dash_logistics/features/authentication/domain/models/auth_state.dart';
import 'package:dash_logistics/features/authentication/infra/auth_controller.dart';
import 'package:dash_logistics/features/authentication/presentation/widgets/animated_truck.dart';
import 'package:dash_logistics/features/authentication/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  static const double _truckH = 105;

  static const List<String> _codes = [
    '+91',
    '+1',
    '+44',
    '+61',
    '+971',
    '+65',
    '+81',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneCtrl = useTextEditingController();
    final nameCtrl = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final selectedCode = useState('+91');

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

    ref.listen<AsyncValue<AuthState>>(authControllerProvider, (previous, next) {
      final prev = previous?.value;
      final curr = next.value;
      if (curr != null && curr.otpSent && (prev == null || !prev.otpSent)) {
        context.pushNamed(AppRoutesName.otpPageName, extra: curr.phone);
      }
      if (next is AsyncError) {
        SnackbarHelper.showError(context, next.error.toString());
      }
    });

    return Scaffold(
      bottomNavigationBar: devAuthEnabled ? SafeArea(child: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: ref.watch(authControllerProvider).isLoading ? null : () =>
              ref.read(authControllerProvider.notifier).loginForTesting(),
          child: const Text('Use test customer account (development)'),
        ),
      )) : null,
      backgroundColor: AppColors.lemon,
      body: Column(
        children: [
          // ── GREEN HEADER (logo + truck) ──────────────────────
          // Shrinks/grows with screen — no fixed pixel top
          SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                // Logo
                SlideTransition(
                  position: anims.logoAnimation,
                  child: Image.asset(
                    "assets/Icons/home/home_appbar_icon.png",
                    height: 68.h,
                    width: 170.w,
                  ),
                ),
                SizedBox(height: 32.h),
                // Truck — sits flush against the white card below
                SlideTransition(
                  position: anims.truckAnimation,
                  child: AnimatedTruckOnCurve(height: _truckH.h)
                ),
              ],
            ),
          ),

          // ── WHITE CARD ───────────────────────────────────────
          // Expands to fill remaining screen — truck is always flush on top
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
                child: LoginFormCard(
                  formKey: formKey,
                  nameCtrl: nameCtrl,
                  phoneCtrl: phoneCtrl,
                  selectedCode: selectedCode,
                  codes: _codes,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
