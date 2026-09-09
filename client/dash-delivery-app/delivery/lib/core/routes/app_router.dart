import 'package:delivary_partner/authentication/registration/domain/registration_step.dart';
import 'package:delivary_partner/authentication/registration/presentation/create_page.dart';
import 'package:delivary_partner/authentication/registration/presentation/documentRequired_page.dart';
import 'package:delivary_partner/authentication/registration/presentation/personal_details.dart';
import 'package:delivary_partner/authentication/registration/presentation/process_completed_screen.dart';
import 'package:delivary_partner/authentication/registration/presentation/training_tutorial_page.dart';
import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
import 'package:delivary_partner/core/infra/secured_storage.dart';
import 'package:delivary_partner/dashobord/e_profile/presentation/qr_scanner_screen.dart';
import 'package:delivary_partner/dashobord/e_profile/presentation/upi_payment_screen.dart';
import 'package:delivary_partner/authentication/registration/presentation/vehicle_detail_page.dart';
import 'package:delivary_partner/core/routes/app_routes_name.dart';
import 'package:delivary_partner/core/routes/app_routes_path.dart';
import 'package:delivary_partner/core/routes/page_transition.dart';
import 'package:delivary_partner/dashobord/a_home/presentation/home_page.dart';
import 'package:delivary_partner/dashobord/b_order/presentation/order_page.dart';
import 'package:delivary_partner/dashobord/d_history/presentation/history_page.dart';
import 'package:delivary_partner/dashobord/dashboard_page.dart';
import 'package:delivary_partner/dashobord/e_profile/presentation/profile_page.dart';
import 'package:delivary_partner/authentication/registration/presentation/bank_details_screen.dart';
import 'package:delivary_partner/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myAppRouterProvider = Provider<GoRouter>((ref) {
  // React to registration step changes so GoRouter re-evaluates redirect
  final progressNotifier = ValueNotifier<RegistrationProgressState>(
    ref.read(registrationProgressProvider),
  );
  ref.listen<RegistrationProgressState>(registrationProgressProvider, (
    _,
    next,
  ) {
    progressNotifier.value = next;
  });

  return GoRouter(
    initialLocation: AppRoutesPath.splashPage,
    refreshListenable: progressNotifier,

    // ── REDIRECT ─────────────────────────────────────────────────────────────
    redirect: (context, state) async {
      final currentPath = state.matchedLocation;

      if (currentPath == AppRoutesPath.splashPage) return null;

      final token = await SecureStorageService.getToken();
      final isLoggedIn = token != null && token.isNotEmpty;

      final progress = ref.read(registrationProgressProvider);
      if (progress.isLoading) return AppRoutesPath.splashPage;

      final step = progress.step;

      // ── Not logged in ─────────────────────────────────────────────────────────
      if (!isLoggedIn) {
        const allowedWhenLoggedOut = [
          AppRoutesPath.loginPage,
          AppRoutesPath.splashPage,
        ];
        if (!allowedWhenLoggedOut.contains(currentPath)) {
          return AppRoutesPath.loginPage;
        }
        return null;
      }

      // ── Logged in + completed → home ──────────────────────────────────────────
      if (step == RegistrationStep.completed) {
        if (_isRegistrationPath(currentPath) ||
            currentPath == AppRoutesPath.loginPage) {
          return AppRoutesPath.homePage;
        }
        return null;
      }

      // ── Logged in + registration in progress ──────────────────────────────────
      final targetPath = _stepToPath(step);

      // Already on the correct step → allow
      if (currentPath == targetPath) return null;

      // ✅ FIX: loginPage must also redirect when logged in with a pending step
      // Previously this was excluded, causing the stuck-on-login bug
      return targetPath;
    },

    routes: [
      // ── Splash ──────────────────────────────────────────────────────────────
      GoRoute(
        name: AppRoutesName.splashPageName,
        path: AppRoutesPath.splashPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const SplashScreen()),
      ),

      // ── Login ────────────────────────────────────────────────────────────────
      GoRoute(
        name: AppRoutesName.loginPageName,
        path: AppRoutesPath.loginPage,
        pageBuilder: (context, state) => PageTransition(child: LoginPage()),
      ),
      GoRoute(
        name: AppRoutesName.trainingTutorialPageName,
        path: AppRoutesPath.trainingTutorialPage,
        pageBuilder: (context, state) => PageTransition(
          child: TrainingTutorialPage(
            videoUrl:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
          ),
        ),
      ),

      // ── Documents Required ───────────────────────────────────────────────────
      GoRoute(
        name: AppRoutesName.documetnRequiredPageName,
        path: AppRoutesPath.documentsRequiredPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const documentsRequiredPage()),
      ),

      // ── Create Account (KYC upload) ──────────────────────────────────────────
      GoRoute(
        name: AppRoutesName.createAccountPageName,
        path: AppRoutesPath.createAccountPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const CreateAccountPage()),
      ),

      // ── Personal Details ─────────────────────────────────────────────────────
      GoRoute(
        name: AppRoutesName.personalDetailsPage,
        path: AppRoutesPath.personalDetailsPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const PersonalDetailsPage()),
      ),

      // ── Vehicle Registration ─────────────────────────────────────────────────
      GoRoute(
        name: AppRoutesName.vehicleRegisterPageName,
        path: AppRoutesPath.registerVehiclePage,
        pageBuilder: (context, state) =>
            PageTransition(child: const VehicleTypeSelectionScreen()),
      ),

      // ── Bank Details ─────────────────────────────────────────────────────────
      GoRoute(
        name: AppRoutesName.bankDetailPageName,
        path: AppRoutesPath.bankDetailPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const BankDetailsScreen()),
      ),

      // ── Dashboard shell (with bottom nav bar) ────────────────────────────────
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => PageTransition(
          child: DashoboardBase(navigationShell: navigationShell),
        ),
        branches: [
          // Branch 0 — Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutesName.homePageName,
                path: AppRoutesPath.homePage,
                pageBuilder: (context, state) =>
                    PageTransition(child: const homePage()),
              ),
            ],
          ),

          // Branch 1 — Orders
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutesName.orderPageName,
                path: AppRoutesPath.orderPage,
                pageBuilder: (context, state) =>
                    PageTransition(child: const OrderPage()),
              ),
            ],
          ),

          // Branch 2 — History
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutesName.historyPageName,
                path: AppRoutesPath.historyPage,
                pageBuilder: (context, state) =>
                    PageTransition(child: const HistoryPage()),
              ),
            ],
          ),

          // Branch 3 — Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutesName.profilePageName,
                path: AppRoutesPath.profilePage,
                pageBuilder: (context, state) =>
                    PageTransition(child: const ProfilePage()),
                routes: [
                  GoRoute(
                    name: AppRoutesName.upiPaymentPageName,
                    path: AppRoutesPath.upiPaymentPage,
                    pageBuilder: (context, state) =>
                        PageTransition(child: const UpiPaymentPage()),
                  ),
                  GoRoute(
                    name: AppRoutesName.qrScannerPageName,
                    path: AppRoutesPath.qrScannerPage,
                    pageBuilder: (context, state) =>
                        PageTransition(child: const QrScannerPage()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// All paths that are part of the registration funnel.
bool _isRegistrationPath(String path) {
  const registrationPaths = [
    AppRoutesPath.trainingTutorialPage,
    AppRoutesPath.documentsRequiredPage,
    AppRoutesPath.createAccountPage,
    AppRoutesPath.personalDetailsPage,
    AppRoutesPath.registerVehiclePage,
    AppRoutesPath.bankDetailPage,
    AppRoutesPath.processCompletedPage,
  ];
  return registrationPaths.contains(path);
}

/// Maps each [RegistrationStep] to the path the user should be on.
String _stepToPath(RegistrationStep step) {
  switch (step) {
    case RegistrationStep.notStarted:
      return AppRoutesPath.loginPage;
    case RegistrationStep.kyc:
      return AppRoutesPath.trainingTutorialPage;
    case RegistrationStep.documentRequiredpage:
      return AppRoutesPath.documentsRequiredPage;
    case RegistrationStep.createAccountPage:
      return AppRoutesPath.createAccountPage;
    case RegistrationStep.personalDetails:
      return AppRoutesPath.personalDetailsPage;
    case RegistrationStep.vehicleDetails:
      return AppRoutesPath.registerVehiclePage;
    case RegistrationStep.bankDetails:
      return AppRoutesPath.bankDetailPage;
    case RegistrationStep.completed:
      return AppRoutesPath.processCompletedPage;
    case RegistrationStep.trainingTutorialPage:
      // TODO: Handle this case.
      throw UnimplementedError();
  }
}

// import 'package:delivary_partner/authentication/presentation/login_page.dart';
// import 'package:delivary_partner/authentication/registration/domain/registration_step.dart';
// import 'package:delivary_partner/authentication/registration/presentation/documentRequired_page.dart';
// import 'package:delivary_partner/authentication/registration/presentation/personal_details.dart';
// import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
// import 'package:delivary_partner/core/infra/secured_storage.dart';
// import 'package:delivary_partner/dashobord/e_profile/presentation/qr_scanner_screen.dart';
// import 'package:delivary_partner/dashobord/e_profile/presentation/upi_payment_screen.dart';
// import 'package:delivary_partner/authentication/registration/presentation/vehicle_detail_page.dart';
// import 'package:delivary_partner/authentication/registration/presentation/create_page.dart';
// import 'package:delivary_partner/core/routes/app_routes_name.dart';
// import 'package:delivary_partner/core/routes/app_routes_path.dart';
// import 'package:delivary_partner/core/routes/page_transition.dart';
// import 'package:delivary_partner/dashobord/a_home/presentation/home_page.dart';
// import 'package:delivary_partner/dashobord/b_order/presentation/order_page.dart';
// import 'package:delivary_partner/dashobord/d_history/presentation/history_page.dart';
// import 'package:delivary_partner/dashobord/dashboard_page.dart';
// import 'package:delivary_partner/dashobord/e_profile/presentation/profile_page.dart';
// import 'package:delivary_partner/authentication/registration/presentation/bank_details_screen.dart';
// import 'package:delivary_partner/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // 🔧 DEV FLAG — set true to skip login/registration and land straight on home.
// //               Flip back to false before release.
// // ─────────────────────────────────────────────────────────────────────────────
// const bool _kBypassAuth = true;

// final myAppRouterProvider = Provider<GoRouter>((ref) {
//   final progressNotifier = ValueNotifier<RegistrationProgressState>(
//     ref.read(registrationProgressProvider),
//   );
//   ref.listen<RegistrationProgressState>(registrationProgressProvider, (
//     _,
//     next,
//   ) {
//     progressNotifier.value = next;
//   });

//   return GoRouter(
//     // Skip splash entirely when bypassing auth
//     initialLocation: _kBypassAuth
//         ? AppRoutesPath.homePage
//         : AppRoutesPath.splashPage,
//     refreshListenable: progressNotifier,

//     // ── REDIRECT ─────────────────────────────────────────────────────────────
//     redirect: (context, state) async {
//       // DEV: no guards — every route is freely accessible
//       if (_kBypassAuth) return null;

//       final currentPath = state.matchedLocation;

//       // Never interrupt splash screen
//       if (currentPath == AppRoutesPath.splashPage) return null;

//       // ── Auth token check ────────────────────────────────────────────────────
//       final token = await SecureStorageService.getToken();
//       final isLoggedIn = token != null && token.isNotEmpty;

//       // ── Registration progress ───────────────────────────────────────────────
//       final progress = ref.read(registrationProgressProvider);

//       // Still reading from disk — stay on splash
//       if (progress.isLoading) return AppRoutesPath.splashPage;

//       final step = progress.step;

//       // ── Not logged in → always send to login ──────────────────────────────
//       if (!isLoggedIn) {
//         const allowedWhenLoggedOut = [
//           AppRoutesPath.loginPage,
//           AppRoutesPath.splashPage,
//         ];
//         if (!allowedWhenLoggedOut.contains(currentPath)) {
//           return AppRoutesPath.loginPage;
//         }
//         return null;
//       }

//       // ── Logged in + registration complete → go to home ────────────────────
//       if (step == RegistrationStep.completed) {
//         if (_isRegistrationPath(currentPath) ||
//             currentPath == AppRoutesPath.loginPage) {
//           return AppRoutesPath.homePage;
//         }
//         return null;
//       }

//       // ── Logged in + registration in progress → send to correct step ───────
//       final targetPath = _stepToPath(step);

//       if (currentPath == targetPath) return null;
//       if (currentPath == AppRoutesPath.homePage) return targetPath;
//       if (!_isRegistrationPath(currentPath) &&
//           currentPath != AppRoutesPath.loginPage) {
//         return targetPath;
//       }

//       return null;
//     },

//     routes: [
//       // ── Splash ──────────────────────────────────────────────────────────────
//       GoRoute(
//         name: AppRoutesName.splashPageName,
//         path: AppRoutesPath.splashPage,
//         pageBuilder: (context, state) =>
//             PageTransition(child: const SplashScreen()),
//       ),

//       // ── Login ────────────────────────────────────────────────────────────────
//       GoRoute(
//         name: AppRoutesName.loginPageName,
//         path: AppRoutesPath.loginPage,
//         pageBuilder: (context, state) =>
//             PageTransition(child: const LoginPage()),
//       ),

//       // ── Documents Required ───────────────────────────────────────────────────
//       GoRoute(
//         name: AppRoutesName.documetnRequiredPageName,
//         path: AppRoutesPath.documentsRequiredPage,
//         pageBuilder: (context, state) =>
//             PageTransition(child: const documentsRequiredPage()),
//       ),

//       // ── Create Account (KYC upload) ──────────────────────────────────────────
//       GoRoute(
//         name: AppRoutesName.createAccountPageName,
//         path: AppRoutesPath.createAccountPage,
//         pageBuilder: (context, state) =>
//             PageTransition(child: const CreateAccountPage()),
//       ),

//       // ── Personal Details ─────────────────────────────────────────────────────
//       GoRoute(
//         name: AppRoutesName.personalDetailsPage,
//         path: AppRoutesPath.personalDetailsPage,
//         pageBuilder: (context, state) =>
//             PageTransition(child: const PersonalDetailsPage()),
//       ),

//       // ── Vehicle Registration ─────────────────────────────────────────────────
//       GoRoute(
//         name: AppRoutesName.vehicleRegisterPageName,
//         path: AppRoutesPath.registerVehiclePage,
//         pageBuilder: (context, state) =>
//             PageTransition(child: const VehicleTypeSelectionScreen()),
//       ),

//       // ── Bank Details ─────────────────────────────────────────────────────────
//       GoRoute(
//         name: AppRoutesName.bankDetailPageName,
//         path: AppRoutesPath.bankDetailPage,
//         pageBuilder: (context, state) =>
//             PageTransition(child: const BankDetailsScreen()),
//       ),

//       // ── Dashboard shell (with bottom nav bar) ────────────────────────────────
//       StatefulShellRoute.indexedStack(
//         pageBuilder: (context, state, navigationShell) => PageTransition(
//           child: DashoboardBase(navigationShell: navigationShell),
//         ),
//         branches: [
//           // Branch 0 — Home
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 name: AppRoutesName.homePageName,
//                 path: AppRoutesPath.homePage,
//                 pageBuilder: (context, state) =>
//                     PageTransition(child: const homePage()),
//               ),
//             ],
//           ),

//           // Branch 1 — Orders
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 name: AppRoutesName.orderPageName,
//                 path: AppRoutesPath.orderPage,
//                 pageBuilder: (context, state) =>
//                     PageTransition(child: const OrderPage()),
//               ),
//             ],
//           ),

//           // Branch 2 — History
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 name: AppRoutesName.historyPageName,
//                 path: AppRoutesPath.historyPage,
//                 pageBuilder: (context, state) =>
//                     PageTransition(child: const HistoryPage()),
//               ),
//             ],
//           ),

//           // Branch 3 — Profile
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 name: AppRoutesName.profilePageName,
//                 path: AppRoutesPath.profilePage,
//                 pageBuilder: (context, state) =>
//                     PageTransition(child: const ProfilePage()),
//                 routes: [
//                   GoRoute(
//                     name: AppRoutesName.upiPaymentPageName,
//                     path: AppRoutesPath.upiPaymentPage,
//                     pageBuilder: (context, state) =>
//                         PageTransition(child: const UpiPaymentPage()),
//                   ),
//                   GoRoute(
//                     name: AppRoutesName.qrScannerPageName,
//                     path: AppRoutesPath.qrScannerPage,
//                     pageBuilder: (context, state) =>
//                         PageTransition(child: const QrScannerPage()),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   );
// });

// // ─── Helpers ──────────────────────────────────────────────────────────────────

// bool _isRegistrationPath(String path) {
//   const registrationPaths = [
//     AppRoutesPath.documentsRequiredPage,
//     AppRoutesPath.createAccountPage,
//     AppRoutesPath.personalDetailsPage,
//     AppRoutesPath.registerVehiclePage,
//     AppRoutesPath.bankDetailPage,
//   ];
//   return registrationPaths.contains(path);
// }

// String _stepToPath(RegistrationStep step) {
//   switch (step) {
//     case RegistrationStep.notStarted:
//       return AppRoutesPath.loginPage;
//     case RegistrationStep.kyc:
//       return AppRoutesPath.createAccountPage;
//     case RegistrationStep.personalDetails:
//       return AppRoutesPath.personalDetailsPage;
//     case RegistrationStep.vehicleDetails:
//       return AppRoutesPath.registerVehiclePage;
//     case RegistrationStep.bankDetails:
//       return AppRoutesPath.bankDetailPage;
//     case RegistrationStep.completed:
//       return AppRoutesPath.homePage;
//     case RegistrationStep.documentRequiredpage:
//       // TODO: Handle this case.
//       throw UnimplementedError();
//     case RegistrationStep.createAccountPage:
//       // TODO: Handle this case.
//       throw UnimplementedError();
//   }
// }
