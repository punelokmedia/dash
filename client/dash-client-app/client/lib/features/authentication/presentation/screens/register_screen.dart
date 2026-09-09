// ignore_for_file: unnecessary_underscores, depend_on_referenced_packages

import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/utils/snackbar_helper.dart';
import 'package:dash_logistics/features/authentication/domain/models/auth_state.dart';
import 'package:dash_logistics/features/authentication/infra/auth_controller.dart';
import 'package:dash_logistics/features/authentication/presentation/widgets/login_header.dart';
import 'package:dash_logistics/features/authentication/presentation/widgets/login_inputfield.dart';
import 'package:dash_logistics/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  static const double _truckH = 105;
  static const double _cardTop = 210;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final porterCtrl = useTextEditingController();
    final refCodeCtrl = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final showRefCode = useState(false);

    ref.listen<AsyncValue<AuthState>>(authControllerProvider, (_, next) {
      next.whenOrNull(
        data: (s) {
          if (s.isLoggedIn) {
            SnackbarHelper.showSuccess(context,'Account created successfully');
            Future.delayed(const Duration(milliseconds: 300), () {
              if (context.mounted) context.goNamed(AppRoutesName.homePageName);
            });
          }
        },
        error: (e, _) => SnackbarHelper.showError(context,e.toString())
      );
    });

    return Scaffold(
      backgroundColor: AppColors.lemon,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── 1. Green background ──────────────────────────
          Positioned.fill(child: ColoredBox(color: AppColors.lemon)),

          // ── 2. White card — top corners rounded only ─────
          Positioned(
            top: _cardTop.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 4,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),

          // ── 3. Logo + truck illustration ─────────────────
          LoginHeader(illustrationHeight: _truckH.h),

          // ── 4. Form — starts exactly at card top ─────────
          Positioned(
            top: _cardTop.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: _RegisterForm(
              formKey: formKey,
              nameCtrl: nameCtrl,
              emailCtrl: emailCtrl,
              porterCtrl: porterCtrl,
              refCodeCtrl: refCodeCtrl,
              showRefCode: showRefCode,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// Form — NO fixed height, fills from cardTop to bottom
// ════════════════════════════════════════════════════════
class _RegisterForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl, emailCtrl, porterCtrl, refCodeCtrl;
  final ValueNotifier<bool> showRefCode;

  const _RegisterForm({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.porterCtrl,
    required this.refCodeCtrl,
    required this.showRefCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final l10n=AppLocalizations.of(context);

    return SingleChildScrollView(
      // ✅ Small top padding — just breathing room below card edge
      padding: EdgeInsets.fromLTRB(28.w, 20.h, 28.w, 24.h),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            // ── Title ──────────────────────────────────────
            Center(
              child: Text(
                l10n.register_title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black37,
                ),
              ),
            ),
            SizedBox(height: 18.h),

            // ── Full name ───────────────────────────────────
            LoginInputField(
              controller: nameCtrl,
              hint:l10n.register_fullname_hint,
              prefixIcon: Icons.person_outline_rounded,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter your name' : null,
            ),
            SizedBox(height: 14.h),

            // ── Email ───────────────────────────────────────
            LoginInputField(
              controller: emailCtrl,
              hint:l10n.register_email_phone_hint,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter Valid Email' : null,
            ),
            SizedBox(height: 14.h),

            // ── Using porter for ────────────────────────────
            DropdownButtonFormField<String>(
              initialValue: porterCtrl.text.isEmpty ? null : porterCtrl.text,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black45,
              ),
              decoration: InputDecoration(
                labelText: l10n.register_using_dash_for,
                labelStyle: TextStyle(color: Colors.black45, fontSize: 14.sp),
                floatingLabelStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 12.sp,
                ),
                prefixIcon: Icon(
                  Icons.local_shipping_outlined,
                  size: 18.r,
                  color: Colors.black45,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.lemon, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1.5,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
              ),
              items:
                  const [
                        'Personal delivery',
                        'Business delivery',
                        'Package transport',
                        'Food delivery',
                      ]
                      .map(
                        (option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) porterCtrl.text = value;
              },
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please select an option' : null,
            ),
            SizedBox(height: 16.h),

            // ── Reference code toggle ───────────────────────
            ValueListenableBuilder<bool>(
              valueListenable: showRefCode,
              builder: (_, show, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => showRefCode.value = !show,
                    child: Text(
                      l10n.register_reference_code,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black37,
                      ),
                    ),
                  ),
                  if (show) ...[
                    SizedBox(height: 10.h),
                    LoginInputField(
                      controller: refCodeCtrl,
                      hint: 'Enter reference code',
                      prefixIcon: Icons.confirmation_number_outlined,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // ── Register button ─────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonLemon,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        if (formKey.currentState?.validate() == true) {
                          ref
                              .read(authControllerProvider.notifier)
                              .createAccount(
                                name: nameCtrl.text.trim(),
                                email: emailCtrl.text.trim(),
                                usage: porterCtrl.text.trim(),
                              );
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 14.h),

            // ── Already have account ────────────────────────
            Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black37,
                    ),
                    children: [
                      TextSpan(
                        text: 'Log In',
                        style: TextStyle(
                          color: AppColors.lemon,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // ── T&C ────────────────────────────────────────
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_box_outline_blank_rounded,
                    size: 14.r,
                    color: AppColors.lemon,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'T & C Apply',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color.fromRGBO(145, 144, 144, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
