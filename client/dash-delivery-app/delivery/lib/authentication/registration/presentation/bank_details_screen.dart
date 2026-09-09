import 'package:delivary_partner/authentication/registration/domain/registration_step.dart';
import 'package:delivary_partner/authentication/registration/infra/bank_details.dart';
import 'package:delivary_partner/authentication/registration/shared/bank_details_provider.dart';
import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/common_widgets.dart';

const _kGreen   = Color(0xFF8DC63F);
const _kFieldBg = Color(0xFFF2F2F2);

const _svgCard = '''
<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round"
    d="M2.25 8.25h19.5M2.25 9h19.5m-16.5 5.25h6m-6 2.25h3
       m-3.75 3h15a2.25 2.25 0 0 0 2.25-2.25V6.75A2.25 2.25 0
       0 0 18.75 4.5h-15a2.25 2.25 0 0 0-2.25 2.25v10.5A2.25
       2.25 0 0 0 3.75 19.5Z" />
</svg>''';

const _svgPerson = '''
<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round"
    d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0Z
       M4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933
       0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
</svg>''';

const _svgGrid = '''
<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round"
    d="M3.75 6A2.25 2.25 0 0 1 6 3.75h2.25A2.25 2.25 0 0 1
       10.5 6v2.25a2.25 2.25 0 0 1-2.25 2.25H6a2.25 2.25 0 0
       1-2.25-2.25V6ZM3.75 15.75A2.25 2.25 0 0 1 6 13.5h2.25a2.25
       2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25
       2.25 0 0 1 3.75 18v-2.25ZM13.5 6a2.25 2.25 0 0 1 2.25-2.25H18A2.25
       2.25 0 0 1 20.25 6v2.25A2.25 2.25 0 0 1 18 10.5h-2.25a2.25
       2.25 0 0 1-2.25-2.25V6ZM13.5 15.75a2.25 2.25 0 0 1 2.25-2.25H18a2.25
       2.25 0 0 1 2.25 2.25V18A2.25 2.25 0 0 1 18 20.25h-2.25A2.25
       2.25 0 0 1 13.5 18v-2.25Z" />
</svg>''';

const _svgSearch = '''
<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round"
    d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5
       7.5 0 0 0 10.607 10.607Z" />
</svg>''';

// ─────────────────────────────────────────────────────────────────────────────

class BankDetailsScreen extends HookConsumerWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state    = ref.watch(bankDetailsProvider);
    final notifier = ref.read(bankDetailsProvider.notifier);

    final accCtrl   = useTextEditingController();
    final reAccCtrl = useTextEditingController();
    final nameCtrl  = useTextEditingController();
    final ifscCtrl  = useTextEditingController();

    final ifscLen      = useState(0);
    final reAccObscure = useState(true);

    // ── IFSC auto-fetch when 11 chars entered ─────────────────────────────
    useEffect(() {
      void onIfscChange() {
        ifscLen.value = ifscCtrl.text.length;
        if (ifscCtrl.text.length == 11) {
          notifier.fetchIfscDetails(ifscCtrl.text);
        }
      }
      ifscCtrl.addListener(onIfscChange);
      return () => ifscCtrl.removeListener(onIfscChange);
    }, []);

    // ── Proceed handler ───────────────────────────────────────────────────
    Future<void> onProceed() async {
      // 1. Basic field validation
      if (state.accountNumber.isEmpty) {
        _showSnack(context, 'Please enter your account number');
        return;
      }
      if (state.accountNumber != state.reEnterAccountNumber) {
        _showSnack(context, 'Account numbers do not match');
        return;
      }
      if (state.name.isEmpty) {
        _showSnack(context, 'Please enter the account holder name');
        return;
      }
      if (state.ifscCode.length != 11) {
        _showSnack(context, 'Please enter a valid 11-character IFSC code');
        return;
      }
      if (state.bankName.isEmpty) {
        _showSnack(context, 'Please select your bank');
        return;
      }

      // 2. Call API via notifier
      final ok = await notifier.submitBankDetails();
      if (!context.mounted) return;

      if (ok) {
        // ✅ Advance step → GoRouter redirect sends user to ProcessCompletedScreen
        // (which is the home/onboarding route mapped to RegistrationStep.completed)
        await ref
            .read(registrationProgressProvider.notifier)
            .advance(RegistrationStep.completed);


            
      }
    }

    return Scaffold(
      backgroundColor: _kGreen,
      body: SafeArea(
        child: Column(
          children: [
            // ── Logo ────────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(top: 42.h, bottom: 10.h),
              child: Center(
                child: Image.asset(
                  'assets/images/png/Group_dash.png',
                  height: 80.h,
                  width: 120.w,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.account_balance_rounded,
                    size: 56.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ── White rounded card ───────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 24,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 28.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Title ──────────────────────────────────
                              Center(
                                child: Text(
                                  'Bank Details',
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.commonButton,
                                  ),
                                ),
                              ),
                              SizedBox(height: 28.h),

                              // ── Account Number ─────────────────────────
                              _BankField(
                                hint: 'Enter Account Number',
                                controller: accCtrl,
                                svgString: _svgCard,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: notifier.setAccountNumber,
                              ),
                              SizedBox(height: 12.h),

                              // ── Re-enter Account Number ────────────────
                              _BankField(
                                hint: 'Re-enter Account Number',
                                controller: reAccCtrl,
                                svgString: _svgCard,
                                keyboardType: TextInputType.number,
                                obscureText: reAccObscure.value,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: notifier.setReEnterAccountNumber,
                                trailing: GestureDetector(
                                  onTap: () => reAccObscure.value =
                                      !reAccObscure.value,
                                  child: Icon(
                                    reAccObscure.value
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18.sp,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),

                              // ── Name ───────────────────────────────────
                              _BankField(
                                hint: 'Name',
                                controller: nameCtrl,
                                svgString: _svgPerson,
                                textCapitalization: TextCapitalization.words,
                                onChanged: notifier.setName,
                              ),
                              SizedBox(height: 12.h),

                              // ── IFSC Code ──────────────────────────────
                              _BankField(
                                hint: 'IFSC Code',
                                controller: ifscCtrl,
                                svgString: _svgGrid,
                                textCapitalization:
                                    TextCapitalization.characters,
                                maxLength: 11,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Z0-9a-z]')),
                                ],
                                onChanged: notifier.setIfscCode,
                                trailing: ifscLen.value == 11
                                    ? Icon(Icons.check_circle_rounded,
                                        color: _kGreen, size: 18.sp)
                                    : Text(
                                        '•••',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.black38,
                                          letterSpacing: 3,
                                          height: 1,
                                        ),
                                      ),
                              ),
                              SizedBox(height: 12.h),

                              // ── Bank Name picker ───────────────────────
                              _BankTile(
                                value: state.bankName,
                                onTap: () => _showBankPicker(
                                  context,
                                  state.bankName,
                                  notifier.setBankName,
                                ),
                              ),
                              SizedBox(height: 28.h),

                              // ── Illustration ───────────────────────────
                              Center(
                                child: Image.asset(
                                  'assets/images/png/cash_machine.png',
                                  height: 130.h,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Icon(
                                    Icons.account_balance_rounded,
                                    size: 72.sp,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // ── API error banner ───────────────────────
                              if (state.errorMessage != null) ...[
                                ErrorBanner(message: state.errorMessage!),
                                SizedBox(height: 12.h),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // ── Proceed button — pinned ──────────────────────
                      Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 20.h),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kGreen,
                              disabledBackgroundColor: Colors.grey.shade300,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            onPressed: state.isSubmitting ? null : onProceed,
                            child: state.isSubmitting
                                ? SizedBox(
                                    width:  22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Proceed',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bank picker bottom sheet ──────────────────────────────────────────────
  void _showBankPicker(
    BuildContext context,
    String selected,
    ValueChanged<String> onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BankPickerSheet(
        selected: selected,
        onSelected: (bank) {
          onSelected(bank);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ── Snackbar helper ───────────────────────────────────────────────────────
  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PILL TEXT FIELD with inline SVG prefix icon
// ─────────────────────────────────────────────
class _BankField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String svgString;
  final Widget? trailing;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  const _BankField({
    required this.hint,
    required this.controller,
    required this.svgString,
    this.trailing,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: _kFieldBg,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        children: [
          SvgPicture.string(
            svgString,
            width:  20.w,
            height: 20.w,
            colorFilter: const ColorFilter.mode(_kGreen, BlendMode.srcIn),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              maxLength: maxLength,
              inputFormatters: inputFormatters,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFFAAAAAA),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                counterText: '',
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 8.w),
            trailing!,
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BANK NAME TILE (non-editable pill)
// ─────────────────────────────────────────────
class _BankTile extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _BankTile({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: _kFieldBg,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            SvgPicture.string(
              _svgSearch,
              width:  20.w,
              height: 20.w,
              colorFilter: const ColorFilter.mode(_kGreen, BlendMode.srcIn),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                value.isEmpty ? 'Bank Name' : value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: value.isEmpty ? const Color(0xFFAAAAAA) : Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded,
                size: 22.sp, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BANK PICKER BOTTOM SHEET
// ─────────────────────────────────────────────
class _BankPickerSheet extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _BankPickerSheet(
      {required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Select Bank',
                style: TextStyle(
                    fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: kBankList.map((b) {
                    final isSel = selected == b.name;
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                      leading: Container(
                        width:  36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: _kGreen.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            b.logo.substring(0, 1),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: _kGreen,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        b.name,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight:
                              isSel ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSel
                          ? Icon(Icons.check_circle,
                              color: _kGreen, size: 20.sp)
                          : null,
                      onTap: () => onSelected(b.name),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }
}