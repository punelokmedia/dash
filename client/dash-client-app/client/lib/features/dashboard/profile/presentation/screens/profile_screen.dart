// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/utils/snackbar_helper.dart';
import 'package:dash_logistics/features/authentication/infra/auth_controller.dart';

import 'package:dash_logistics/features/dashboard/change_language/presentation/widgets/change_langauge_sheet.dart';
import 'package:dash_logistics/features/dashboard/profile/presentation/widgets/profile_menu.dart';
import 'package:dash_logistics/features/dashboard/profile/presentation/widgets/profile_user.dart';
import 'package:dash_logistics/features/dashboard/profile/shared/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = useState(4);
    final profileState = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);

    // Load profile once when screen mounts
    useEffect(() {
      Future.microtask(() => controller.loadProfile());
      return null;
    }, []);

    // Show error snackbar if API fails
    ref.listen(profileControllerProvider, (_, next) {
      if (next.errorMessage != null) {
        SnackbarHelper.showError(
            context, 
            next.errorMessage!,
          );
        controller.clearError();
      }
    });

    // Use live data, fall back to '—' while loading
    final userName = profileState.profile?.fullName ?? '—';
    final userEmail = profileState.profile?.email ?? '—';

    Future<void> handleLogout() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      await ref.read(authControllerProvider.notifier).logout();

      if (!context.mounted) return;

      // ✅ only navigate if logout succeeded (state is AsyncData with isLoggedIn false)
      final authState = ref.read(authControllerProvider);
      authState.whenOrNull(
        data: (state) {
          if (!state.isLoggedIn) {
            context.goNamed(
              AppRoutesName.loginPageName,
            ); // ✅ navigate on success
          }
        },
        error: (e, _) {
          // ✅ show snackbar if logout failed
          SnackbarHelper.showError(
            context, 
            'Logout failed. Please check your connection and try again.',
          );
        
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── App bar ────────────────────────────────────────
          _ProfileAppBar(),

          // ── Scrollable content ─────────────────────────────
          Expanded(
            child: profileState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    child: Column(
                      children: [
                        // User card
                        ProfileUserCard(
                          name: userName,
                          email: userEmail,
                          onEdit: () {},
                        ),
                        SizedBox(height: 16.h),

                        // Menu card
                        ProfileMenuCard(
                          rewardsCount: 0,
                          onSavedAddresses: () {
                            log(
                              'onsavedaddress tapped — navigating to: ${AppRoutesName.savedAddressPageName}',
                            );
                            context.pushNamed(
                              AppRoutesName.savedAddressPageName,
                            );
                          },
                          onGst: () {
                            log(
                              'onGst tapped — navigating to: ${AppRoutesName.gstPagename}',
                            );
                            context.pushNamed(AppRoutesName.gstPagename);
                          },
                          onRewards: () {},
                          onRefer: () {},
                          onHelp: () {
                            log(
                              'onhelpsupport tapped - navigating to: ${AppRoutesName.helpSupport}',
                            );
                            context.pushNamed(AppRoutesName.helpSupport);
                          },
                          onLanguage: () => openLanguageSheet(context),
                          onTerms: () {
                            log(
                              'onTerms tapped - navigating to: ${AppRoutesName.termsPageName}',
                            );
                            context.pushNamed(AppRoutesName.termsPageName);
                          },
                          onLogout: handleLogout,
                        ),
                        SizedBox(height: 24.h),

                        // Truck illustration
                        Image.asset(
                          'assets/Icons/login_icon.png',
                          height: 105.h,
                          width: 167.w,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
          ),

          // // ── Bottom nav ─────────────────────────────────────
          // DashBottomNavBar(
          //   currentIndex: navIndex.value,
          //   onTap: (i) => navIndex.value = i,
          // ),
        ],
      ),
    );
  }
}

// ── App Bar ────────────────────────────────────────────────
class _ProfileAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      color: AppColors.lemon,
      padding: EdgeInsets.only(top: 30.h, left: 20.w, right: 20.w, bottom: 0.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> openLanguageSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ChangeLanguageSheet(),
  );
}
