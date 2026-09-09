// profile_screen.dart
// Dash Delivery Partner — Profile Screen
// Matches Figma exactly: green scaffold → white card overlay → content

import 'dart:io';
import 'package:delivary_partner/authentication/shared/authprovider.dart';
import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:delivary_partner/core/routes/app_routes_name.dart';
import 'package:delivary_partner/dashobord/e_profile/domain/models.dart';
import 'package:delivary_partner/dashobord/e_profile/shared/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const _kGreen = Color(0xFF8BBB22);
const _kCardGreen = Color(0xFF7AAD18);
const _kOrange = Color(0xFFFF6B35);
const _kAvatarBg = Color(0xFFFFF3E0);
const _kLogoutRed = Color.fromRGBO(241, 86, 35, 1);
const _kTextDark = Color(0xFF1A1A1A);
const _kTextMedium = Color(0xFF555555);

// ── Screen ────────────────────────────────────────────────────────────────────
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final profileAsync = ref.watch(profileProvider);
    final pickerBusy = useState(false);

    return Scaffold(
      backgroundColor: _kGreen,
      body: profileAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, _) => _ErrorBody(
          message: e.toString(),
          onRetry: () => ref.read(profileProvider.notifier).refresh(),
        ),
        data: (profile) => _Body(
          profile: profile,
          pickerBusy: pickerBusy,
          onPickImage: () => _pickImage(context, ref, pickerBusy),
        ),
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext ctx,
    WidgetRef ref,
    ValueNotifier<bool> busy,
  ) async {
    if (busy.value) return;
    final picker = ImagePicker();
    await showModalBottomSheet(
      context: ctx,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: _kGreen),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(ctx);
                final f = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (f != null) {
                  busy.value = true;
                  await ref
                      .read(profileProvider.notifier)
                      .uploadProfileImage(File(f.path));
                  busy.value = false;
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: _kGreen),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(ctx);
                final f = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (f != null) {
                  busy.value = true;
                  await ref
                      .read(profileProvider.notifier)
                      .uploadProfileImage(File(f.path));
                  busy.value = false;
                }
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

// ── Main body: green scaffold + white card (mirrors documentsRequiredPage) ────
class _Body extends StatelessWidget {
  final ProfileModel profile;
  final ValueNotifier<bool> pickerBusy;
  final VoidCallback onPickImage;

  const _Body({
    required this.profile,
    required this.pickerBusy,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        SizedBox(height: 15.h,),
        _AppBar(name: profile.name),
        Expanded(
          child: Padding(
            padding:  EdgeInsets.fromLTRB(16.w,20.h,16.w,0.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
                  child: Column(
                    children: [
                      // ── Avatar (overlaps top of card) ──────────────────────
                      SizedBox(height: 16.h),
                      _AvatarSection(
                        name: profile.name,
                        imageUrl: profile.profileImageUrl,
                        isBusy: pickerBusy.value,
                        onEdit: onPickImage,
                      ),
                      SizedBox(height: 10.h),
            
                      // ── Name ────────────────────────────────────────────────
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16.sp, color: _kTextDark),
                          children: [
                            TextSpan(
                              text: 'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24.sp,
                                color: AppColors.commonText,
                              ),
                            ),
                            TextSpan(
                              text: '  -  ${profile.name}',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Color.fromRGBO(143, 147, 148, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
            
                      // ── Vehicle card ────────────────────────────────────────
                      _VehicleCard(profile: profile),
                      SizedBox(height: 14.h),
            
                      // ── Refer a friend ──────────────────────────────────────
                      _MenuCard(
                        items: [
                          _MenuItem(
                            icon: Icons.card_giftcard_outlined,
                            label: 'Refer a friend',
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
            
                      // ── Settings ────────────────────────────────────────────
                      _MenuCard(
                        items: [
                          _MenuItem(
                            icon: Icons.translate_rounded,
                            label: 'Change Language',
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.description_outlined,
                            label: 'Terms & Conditions',
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Help & support',
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.logout_rounded,
                            label: 'Log Out',
                            labelColor: _kLogoutRed,
                            iconColor: _kLogoutRed,
                            onTapWithRef: (ctx, ref) {
                              _logout(context, ref);
                            },
                            showDivider: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _logout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Cancel', style: TextStyle(color: _kTextMedium)),
          ),
          TextButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
            child: const Text('Log Out', style: TextStyle(color: _kLogoutRed)),
          ),
        ],
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final String name;
  const _AppBar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // ── Back button ────────────────────────────────────────
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 37.sp,
            ),
          ),

          // ── Title ──────────────────────────────────────────────
          Expanded(
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // ── Avatar + QR badge ──────────────────────────────────
          SizedBox(
            width: 60.w,
            height: 60.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Avatar circle
                Container(
                  width: 52.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'M',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: _kOrange,
                      ),
                    ),
                  ),
                ),

                // QR badge — bottom-right
                Positioned(
                  bottom: 5.h,
                  right: 6.4.w,
                  child: Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: _kOrange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5.r),
                      boxShadow: [
                        BoxShadow(
                          color: _kOrange.withOpacity(0.40),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.goNamed(AppRoutesName.upiPaymentPageName);
                      },
                      child: Center(
                        child: Icon(
                          Icons.qr_code_2_rounded,
                          size: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Avatar section ────────────────────────────────────────────────────────────
class _AvatarSection extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final bool isBusy;
  final VoidCallback onEdit;

  const _AvatarSection({
    required this.name,
    required this.imageUrl,
    required this.isBusy,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96.w,
      height: 108.w, // extra space for the badge overlap
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // ── Avatar circle ──────────────────────────────────────
          Container(
            width: 96.w,
            height: 96.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kAvatarBg,
              border: Border.all(color: _kOrange, width: 3.5.r),
              boxShadow: [
                BoxShadow(
                  color: _kOrange.withOpacity(0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: isBusy
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: _kGreen,
                        strokeWidth: 2,
                      ),
                    )
                  : imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _defaultAvatar(),
                    )
                  : Image.asset(
                      "assets/images/png/person.png",
                      fit: BoxFit.contain,
                    ),
            ),
          ),

          // ── Edit badge — overlaps bottom-right of circle ───────
          Positioned(
            bottom: 0,
            right: -4.w,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: _kOrange,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: _kOrange.withOpacity(0.40),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.edit_rounded, size: 11.sp, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() => Icon(
    Icons.person_rounded,
    size: 52.sp,
    color: _kOrange.withOpacity(0.80),
  );
}

// ── Vehicle card ──────────────────────────────────────────────────────────────
class _VehicleCard extends StatelessWidget {
  final ProfileModel profile;
  const _VehicleCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 185.h,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: _kCardGreen,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: _kCardGreen.withOpacity(0.38),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top: info + scooter image ──────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                 
                    SizedBox(height: 5.h),
                    _VRow(label: 'Vehicle No *', value: profile.vehicleRc),
                    SizedBox(height: 12.h),
                    _VRow(label: 'Fuel Type *', value: profile.fuelType),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              // Scooter image box
              Container(
                width: 86.w,
                height: 86.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Image.asset(
                    'assets/images/png/green_scooter.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // ── Number plate — full width centered ────────────────────
          Center(
            child: Text(
              profile.numberPlate,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..color = Colors.white,
                shadows: [
                  // outer stroke effect
                  Shadow(
                    color: Colors.black38,
                    offset: Offset(1.5, 1.5),
                    blurRadius: 0,
                  ),
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(-1, -1),
                    blurRadius: 0,
                  ),
                  // soft depth
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // ── Date of Manufacture ────────────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Date of Manufacture * - ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: profile.dateOfManufacture,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VRow extends StatelessWidget {
  final String label;
  final String value;
  const _VRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 18.sp, color: Colors.white, height: 1.3),
        children: [
          TextSpan(
            text: '$label  ',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

// ── Menu card ─────────────────────────────────────────────────────────────────
class _MenuItemData {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final Color? iconColor;
  final VoidCallback? onTap; // Make optional
  final void Function(BuildContext, WidgetRef)? onTapWithRef; // NEW
  final bool showDivider;

  const _MenuItemData({
    required this.icon,
    required this.label,
    this.onTap,
    this.onTapWithRef, // NEW
    this.labelColor,
    this.iconColor,
    this.showDivider = true,
  });
}

// alias so existing code using _MenuItem still compiles
typedef _MenuItem = _MenuItemData;

class _MenuCard extends HookConsumerWidget {
  final List<_MenuItemData> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // CHANGED: Check which callback to use
                    if (item.onTapWithRef != null) {
                      item.onTapWithRef!(context, ref);
                    } else if (item.onTap != null) {
                      item.onTap!();
                    }
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 23.sp,
                          color:
                              item.iconColor ?? Color.fromRGBO(94, 103, 105, 1),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color:
                                  item.labelColor ??
                                  Color.fromRGBO(94, 103, 105, 1),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 22.sp,
                          color: Color.fromRGBO(94, 103, 105, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLast && item.showDivider)
                Divider(
                  height: 1,
                  thickness: 2,
                  color: Color.fromRGBO(204, 204, 204, 1),
                  indent: 16.w,
                  endIndent: 16.w,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Error body ────────────────────────────────────────────────────────────────
class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: Colors.white70,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: Colors.white),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: _kGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
