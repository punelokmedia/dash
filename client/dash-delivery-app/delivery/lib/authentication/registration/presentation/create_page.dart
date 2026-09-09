import 'dart:io';
import 'package:delivary_partner/authentication/registration/domain/create_account.dart';
import 'package:delivary_partner/authentication/registration/domain/registration_step.dart';
import 'package:delivary_partner/authentication/registration/shared/create_account_provider.dart';
import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

const _kGreen = Color(0xFF8DC63F);

// ─── Page ──────────────────────────────────────────────────────────────────────
class CreateAccountPage extends HookConsumerWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(createAccountProvider);
    final picker = useMemoized(() => ImagePicker());

    final profileImage = useState<File?>(null);
    final aadhaarFile = useState<File?>(null);
    final panFile = useState<File?>(null);
    final licenseFile = useState<File?>(null);

    final aadhaarUploaded = useState(false);
    final panUploaded = useState(false);
    final licenseUploaded = useState(false);

    // ── Listen for API errors only ─────────────────────────────────────────────
    // NOTE: isSuccess navigation is handled via advance() below, not here.
    ref.listen<CreateAccountState>(createAccountProvider, (_, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    // ── Helpers ────────────────────────────────────────────────────────────────
    Future<File?> pickImage(ImageSource source) async {
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      return picked != null ? File(picked.path) : null;
    }

    void showSourceSheet(
      ValueNotifier<File?> target, {
      void Function(File)? onFilePicked,
    }) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (_) => SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_rounded, color: _kGreen),
                  title: const Text('Take Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    final f = await pickImage(ImageSource.camera);
                    if (f != null) {
                      target.value = f;
                      onFilePicked?.call(f);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    color: _kGreen,
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final f = await pickImage(ImageSource.gallery);
                    if (f != null) {
                      target.value = f;
                      onFilePicked?.call(f);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── Proceed handler ────────────────────────────────────────────────────────
    Future<void> onProceed() async {
      // 1. Validate all docs uploaded
      if (!aadhaarUploaded.value ||
          !panUploaded.value ||
          !licenseUploaded.value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload all required documents'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // 2. Upload profile image if selected
      if (profileImage.value != null) {
        await ref
            .read(createAccountProvider.notifier)
            .uploadProfileImage(profileImage: profileImage.value);

        if (!ref.read(createAccountProvider).isProfileImageUploaded) {
          // uploadProfileImage already set an error — listener shows snackbar
          return;
        }
      }

      // 3. Advance step → router redirect will navigate to PersonalDetailsPage
      await ref
          .read(registrationProgressProvider.notifier)
          .advance(RegistrationStep.personalDetails);
    }

    // ── UI ─────────────────────────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: const Color(0xFF8DC63F),
      body: SafeArea(
        child: Column(
          children: [
            // ── Green header with logo ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(top: 40.h, bottom: 24.h),
              child: Center(
                child: Image.asset(
                  'assets/images/png/dash_logo.png',
                  height: 80.h,
                  width: 140.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ── White card ─────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              SizedBox(height: 28.h),

                              // ── Title ──────────────────────────────────────────
                              Text(
                                'Create your Account',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),

                              SizedBox(height: 24.h),

                              // ── Profile avatar ─────────────────────────────────
                              GestureDetector(
                                onTap: () => showSourceSheet(profileImage),
                                child: Container(
                                  width: 88.w,
                                  height: 88.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFFF0C8),
                                    border: Border.all(
                                      color: const Color(0xFFFFD966),
                                      width: 4.r,
                                    ),
                                    image: profileImage.value != null
                                        ? DecorationImage(
                                            image: FileImage(
                                              profileImage.value!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: profileImage.value == null
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

                              // ── Documents group card ───────────────────────────
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Colors.grey.shade200,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // ── Aadhaar ──────────────────────────────────
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.r),
                                        topRight: Radius.circular(16.r),
                                      ),
                                      child: ColoredBox(
                                        color: Colors.white,
                                        child: _DocUploadCard(
                                          label: 'AADHAAR Card *',
                                          subtitle: 'Front photo',
                                          iconAsset:
                                              'assets/images/png/aadhaar.png',
                                          isUploaded: aadhaarUploaded.value,
                                          isLoading:
                                              accountState.isLoading &&
                                              !aadhaarUploaded.value,
                                          onTap: () => showSourceSheet(
                                            aadhaarFile,
                                            onFilePicked: (file) async {
                                              aadhaarUploaded.value = false;
                                              await ref
                                                  .read(
                                                    createAccountProvider
                                                        .notifier,
                                                  )
                                                  .uploadAadhaar(aadhaar: file);
                                              if (ref
                                                  .read(createAccountProvider)
                                                  .isAadhaarUploaded) {
                                                aadhaarUploaded.value = true;
                                              } else {
                                                aadhaarFile.value = null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 2.h),

                                    // ── PAN ──────────────────────────────────────
                                    ColoredBox(
                                      color: Colors.white,
                                      child: _DocUploadCard(
                                        label: 'PAN Card *',
                                        subtitle: 'Upload clear photo',
                                        iconAsset:
                                            'assets/images/png/pan_card.png',
                                        isUploaded: panUploaded.value,
                                        isLoading:
                                            accountState.isLoading &&
                                            !panUploaded.value,
                                        onTap: () => showSourceSheet(
                                          panFile,
                                          onFilePicked: (file) async {
                                            panUploaded.value = false;
                                            await ref
                                                .read(
                                                  createAccountProvider
                                                      .notifier,
                                                )
                                                .uploadPan(pan: file);
                                            if (ref
                                                .read(createAccountProvider)
                                                .isPanUploaded) {
                                              panUploaded.value = true;
                                            } else {
                                              panFile.value = null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 2.h),

                                    // ── Driving License ───────────────────────────
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16.r),
                                        bottomRight: Radius.circular(16.r),
                                      ),
                                      child: ColoredBox(
                                        color: Colors.white,
                                        child: _DocUploadCard(
                                          label: 'Driving License *',
                                          subtitle: 'Upload clear photo',
                                          iconAsset:
                                              'assets/images/png/driving_license.png',
                                          isUploaded: licenseUploaded.value,
                                          isLoading:
                                              accountState.isLoading &&
                                              !licenseUploaded.value,
                                          onTap: () => showSourceSheet(
                                            licenseFile,
                                            onFilePicked: (file) async {
                                              licenseUploaded.value = false;
                                              await ref
                                                  .read(
                                                    createAccountProvider
                                                        .notifier,
                                                  )
                                                  .uploadLicense(license: file);
                                              if (ref
                                                  .read(createAccountProvider)
                                                  .isLicenseUploaded) {
                                                licenseUploaded.value = true;
                                              } else {
                                                licenseFile.value = null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),

                      // ── Proceed button — pinned at bottom ──────────────────────
                      Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
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
                            onPressed: accountState.isLoading
                                ? null
                                : onProceed,
                            child: accountState.isLoading
                                ? SizedBox(
                                    width: 22.w,
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

                      // ── Already have an account ──────────────────────────────
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

// ─── Doc Upload Card ───────────────────────────────────────────────────────────
class _DocUploadCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final String iconAsset;
  final bool isUploaded;
  final bool isLoading;
  final VoidCallback onTap;

  const _DocUploadCard({
    required this.label,
    required this.subtitle,
    required this.iconAsset,
    required this.isUploaded,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        children: [
          // ── Icon box ────────────────────────────────────────────────────────
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Image.asset(
              iconAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.description_outlined,
                color: Colors.grey,
                size: 22.sp,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // ── Label + subtitle ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // ── Upload button + status ───────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: isLoading ? null : onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? const Color(0xFFE8F8EF)
                        : const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 14.w,
                          height: 14.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _kGreen,
                          ),
                        )
                      : Text(
                          isUploaded ? 'Uploaded' : 'Upload',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: isUploaded ? _kGreen : Colors.black54,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                isUploaded ? 'Uploaded ✓' : 'Not Uploaded',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isUploaded ? _kGreen : Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
