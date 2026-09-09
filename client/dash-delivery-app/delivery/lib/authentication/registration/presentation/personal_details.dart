
import 'package:delivary_partner/authentication/registration/domain/create_account.dart';
import 'package:delivary_partner/authentication/registration/domain/registration_step.dart';
import 'package:delivary_partner/authentication/registration/shared/create_account_provider.dart'; // ✅ added
import 'package:delivary_partner/authentication/registration/shared/personal_details_provider.dart';
import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:delivary_partner/core/routes/app_routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ✅ removed: image_picker import — not needed anymore

const _kGreen = Color(0xFF8DC63F);

class PersonalDetailsPage extends HookConsumerWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalDetailsProvider);

    // ✅ read profile image from createAccountProvider — no local picker
    final profileImageFile = ref.watch(
      createAccountProvider.select((s) => s.profileImageFile),
    );

    final fullNamecontroller = useTextEditingController();
    final emailController    = useTextEditingController();
    final addrController     = useTextEditingController();
    final selectedCity       = useState<String?>(null);
    // ✅ removed: profileImage useState
    // ✅ removed: picker useMemoized
    // ✅ removed: pickProfileImage() function

    // ── Listen: advance on success, show snackbar on error ───────────────────
    ref.listen<PersonalDetailsState>(personalDetailsProvider, (_, next) async {
      if (next.isSuccess) {
        await ref
            .read(registrationProgressProvider.notifier)
            .advance(RegistrationStep.vehicleDetails);
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    // ── Scooter ride animation ────────────────────────────────────────────────
    final animController = useAnimationController(
      duration: const Duration(seconds: 5),
    )..repeat();

    final rideAnim = useAnimation(
      Tween<double>(begin: 100, end: -100).animate(
        CurvedAnimation(parent: animController, curve: Curves.linear),
      ),
    );

    // ── Submit handler ────────────────────────────────────────────────────────
    void onNext() {
      if (fullNamecontroller.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (selectedCity.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a city'),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (addrController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter your address'),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }

      ref.read(personalDetailsProvider.notifier).submit(
            full_name: fullNamecontroller.text.trim(),
            email:    emailController.text.trim(),
            address:  addrController.text.trim(),
            city:     selectedCity.value!,
          );
    }

    // ── UI ────────────────────────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: _kGreen,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.w, 30.h, 15.w, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 28.h),

                              // ── Title row with back button ──────────────────
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: () => context.goNamed(
                                        AppRoutesName.createAccountPageName,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          size: 22.sp,
                                          color: const Color.fromRGBO(138, 138, 138, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Personal Details',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.commonButton,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 24.h),

                              // ── Profile avatar — read-only from CreateAccountPage ──
                              Center(
                                child: Container(  // ✅ no GestureDetector — not tappable
                                  width: 88.w,
                                  height: 88.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFFF0C8),
                                    border: Border.all(
                                      color: const Color(0xFFFFD966),
                                      width: 4.r,
                                    ),
                                    image: profileImageFile != null
                                        ? DecorationImage(
                                            image: FileImage(profileImageFile),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: profileImageFile == null
                                      ? ClipOval(
                                          child: Image.asset(
                                            'assets/images/png/person.png',
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) => Icon(
                                              Icons.person,
                                              size: 40.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),

                              SizedBox(height: 28.h),

                              // ── Name ────────────────────────────────────────
                              _label('Name *'),
                              SizedBox(height: 6.h),
                              _IconInputField(
                                controller: fullNamecontroller,
                                hint: 'Enter your name',
                                icon: Icons.person_outline_rounded,
                                keyboardType: TextInputType.name,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                              ),

                              SizedBox(height: 16.h),

                              // ── Email ────────────────────────────────────────
                              _label('Email ID *'),
                              SizedBox(height: 6.h),
                              _IconInputField(
                                controller: emailController,
                                hint: 'Enter your email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              SizedBox(height: 16.h),

                              // ── City dropdown ────────────────────────────────
                              _label('Select City *'),
                              SizedBox(height: 6.h),
                              Container(
                                height: 52.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.20),
                                      blurRadius: 6,
                                      spreadRadius: -2,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_city_outlined,
                                        size: 20.sp, color: Colors.grey.shade400),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedCity.value,
                                          hint: Text('Select city',
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.grey.shade400)),
                                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                                              color: Colors.grey.shade500, size: 22.sp),
                                          isExpanded: true,
                                          style: TextStyle(
                                              fontSize: 14.sp, color: Colors.black87),
                                          items: state.cities
                                              .map((c) => DropdownMenuItem(
                                                    value: c,
                                                    child: Text(c),
                                                  ))
                                              .toList(),
                                          onChanged: (v) => selectedCity.value = v,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // ── Address ──────────────────────────────────────
                              _label('Address *'),
                              SizedBox(height: 6.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.20),
                                      blurRadius: 6,
                                      spreadRadius: -2,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 14.h),
                                      child: Icon(Icons.location_on_outlined,
                                          size: 20.sp, color: Colors.grey.shade400),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: TextField(
                                        controller: addrController,
                                        keyboardType: TextInputType.streetAddress,
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontSize: 14.sp, color: Colors.black87),
                                        decoration: InputDecoration(
                                          hintText: 'Enter your address',
                                          hintStyle: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey.shade400),
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 14.h),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 28.h),

                              // ── Animated scooter ─────────────────────────────
                              Center(
                                child: Transform.translate(
                                  offset: Offset(rideAnim, 0),
                                  child: Image.asset(
                                    'assets/images/png/Frame.png',
                                    height: 72.h,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) => SizedBox(height: 72.h),
                                  ),
                                ),
                              ),

                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ),

                      // ── Next button — pinned ──────────────────────────────────
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
                            onPressed: state.isLoading ? null : onNext,
                            child: state.isLoading
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Next',
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
}

// ── Label ──────────────────────────────────────────────────────────────────────
Widget _label(String text) => Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(94, 103, 105, 1),
        ),
      ),
    );

// ── Input field with leading icon ──────────────────────────────────────────────
class _IconInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _IconInputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey.shade400),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}