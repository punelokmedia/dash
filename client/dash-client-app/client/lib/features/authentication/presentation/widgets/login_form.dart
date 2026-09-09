import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/authentication/infra/auth_controller.dart';
import 'package:dash_logistics/features/authentication/presentation/widgets/login_inputfield.dart';
import 'package:dash_logistics/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginFormCard extends ConsumerWidget {
  // ⚠️ height removed — form now fills the card container naturally
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final ValueNotifier<String> selectedCode;
  final List<String> codes;

  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.selectedCode,
    required this.codes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      // ── top padding = 24h so "Hello!" starts right below the curve arc
      padding: EdgeInsets.fromLTRB(28.w, 41.h, 28.w, 40.h),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Hello / Welcome ──────────────────────────────
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${l10n.login_title}\n',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 41.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lemon,
                    ),
                  ),
                  TextSpan(
                    text: l10n.login_title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 21.h),

            Text(
              l10n.login_heading,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 20.h),

            // ── Phone row ────────────────────────────────────
            _PhoneRow(
              phoneCtrl: phoneCtrl,
              selectedCode: selectedCode,
              codes: codes,
            ),

            SizedBox(height: 24.h),

            // ── Login button ─────────────────────────────────
            _LoginButton(
              isLoading: isLoading,
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  final phone = '${selectedCode.value}${phoneCtrl.text}';
                  ref.read(authControllerProvider.notifier).sendOtp(phone);
                }
              },
            ),

            // ── Forgot password ──────────────────────────────
            TextButton(
              onPressed: () {},
              child: Text(
                l10n.login_forgot_password,
                style: TextStyle(fontSize: 13.sp, color: Colors.black54),
              ),
            ),

            _OrDivider(),
            SizedBox(height: 16.h),
            _SocialRow(),
            SizedBox(height: 20.h),
            _TandC(),
          ],
        ),
      ),
    );
  }
}

// ── Phone Row ──────────────────────────────────────────────
class _PhoneRow extends StatelessWidget {
  final TextEditingController phoneCtrl;
  final ValueNotifier<String> selectedCode;
  final List<String> codes;

  const _PhoneRow({
    required this.phoneCtrl,
    required this.selectedCode,
    required this.codes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Phone icon
              Icon(Icons.phone_outlined, size: 18.r, color: Colors.grey[500]),
              SizedBox(width: 10.w),

              // Country code
              ValueListenableBuilder<String>(
                valueListenable: selectedCode,
                builder: (context, code, _) => Text(
                  code,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: 6.w),

              // Phone number input (no border, flat)
              Expanded(
                child: TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: TextStyle(fontFamily: 'Roboto',fontSize: 14.sp, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Enter Mobile Number',
                    hintStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.sp,
                      color: Colors.grey[400],
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    // contentPadding: EdgeInsets.zero,
                    // Keep your cancel icon
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: phoneCtrl,
                      builder: (context, value, _) {
                        return value.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () => phoneCtrl.clear(),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 4.w),
                                  child: Icon(
                                    Icons.cancel_rounded,
                                    size: 18.r,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 24.w,
                      minHeight: 24.h,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter phone number';
                    if (v.length != 10) return 'Must be 10 digits';
                    return null;
                  },
                ),
              ),

            
            ],
          ),
        ),

        // Bottom divider
        Divider(height: 1, thickness: 1, color: Colors.grey[300]),
      ],
    );
  }
}

// ── Login Button ───────────────────────────────────────────
class _LoginButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({required this.isLoading, required this.onPressed});

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  @override
  Widget build(BuildContext context) {
    final l10n=AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lemon,
          elevation: 2,
          shadowColor: AppColors.buttonLemon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        onPressed: widget.isLoading ? null : widget.onPressed,
        child: widget.isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Text(
                l10n.login_button,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ── OR Divider ─────────────────────────────────────────────
class _OrDivider extends StatefulWidget {
  @override
  State<_OrDivider> createState() => _OrDividerState();
}

class _OrDividerState extends State<_OrDivider> {
  @override
  Widget build(BuildContext context) {
    final l10n=AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Text(
            l10n.login_or,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }
}

// ── Social Row ─────────────────────────────────────────────
class _SocialRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          image: "assets/Icons/login_icon/google.png",
          onTap: () {},
        ),
        SizedBox(width: 16.w),
        SocialButton(
          image: "assets/Icons/login_icon/apple.png", 
          onTap: () {}),
        SizedBox(width: 16.w),
        SocialButton(
          image:"assets/Icons/login_icon/facebook.png",
          onTap: () {},
        ),
      ],
    );
  }
}

// ── T&C ────────────────────────────────────────────────────
class _TandC extends StatefulWidget {
  @override
  State<_TandC> createState() => _TandCState();
}

class _TandCState extends State<_TandC> {
  @override
  Widget build(BuildContext context) {
    final l10n=AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_box_outline_blank_rounded,
          size: 14.r,
          color: AppColors.lemon,
        ),
        SizedBox(width: 4.w),
        Text(
          l10n.login_terms,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.lemon,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
