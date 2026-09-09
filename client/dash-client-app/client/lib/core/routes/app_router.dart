// ignore_for_file: unused_local_variable

import 'package:dash_logistics/features/authentication/infra/auth_controller.dart';
import 'package:dash_logistics/features/authentication/presentation/screens/login_screen.dart';
import 'package:dash_logistics/features/authentication/presentation/screens/otp_screen.dart';
import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/routes/app_routes_path.dart';
import 'package:dash_logistics/core/routes/page_transition.dart';
import 'package:dash_logistics/features/authentication/presentation/screens/register_screen.dart';
import 'package:dash_logistics/features/authentication/presentation/screens/splash_screen.dart';
import 'package:dash_logistics/features/dashboard/add_address/presentation/screens/add_address_screen.dart';
import 'package:dash_logistics/features/dashboard/add_gst/presentation/screens/add_gst_screen.dart';
import 'package:dash_logistics/features/dashboard/address/domain/address_model.dart';
import 'package:dash_logistics/features/dashboard/address/presentation/screen/edit_address_screen.dart';
import 'package:dash_logistics/features/dashboard/help_support/presentation/screens/help_support_screen.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/screen/contact_details.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/screen/location_page.dart';
import 'package:dash_logistics/features/dashboard/review_booking/presentation/screens/review_booking_screen.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/screen/vehicle_screen.dart';
import 'package:dash_logistics/features/dashboard/orders_history_pages/presentation/screens/orders_screen.dart';
import 'package:dash_logistics/features/dashboard/payment/presentation/screens/pay_successful_screen.dart';
import 'package:dash_logistics/features/dashboard/payment/presentation/screens/track_order.dart';
// import 'package:dash_logistics/features/dashboard/payments/presentation/screens/payment_screen.dart';
import 'package:dash_logistics/features/dashboard/profile/presentation/screens/profile_screen.dart';
import 'package:dash_logistics/features/dashboard/terms_and_conditions/presentation/screens/terms_page.dart';
import 'package:dash_logistics/features/dashboard/trip_details/presentation/screens/trip_details_screen.dart';
import 'package:dash_logistics/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dash_logistics/features/dashboard/address/presentation/screen/saved_address_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier<bool>(false);

  ref.listen(authControllerProvider, (_, _) {
    refreshNotifier.value = !refreshNotifier.value;
  });

  return GoRouter(
    initialLocation: AppRoutesPath.splashPage,
    refreshListenable: refreshNotifier,

    // lib/core/routes/app_router.dart
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider).value;
      if (auth == null) return null;

      final bool isLoggedIn = auth.isLoggedIn;
      final String location = state.matchedLocation;

      final bool isAtLogin = location == AppRoutesPath.loginPage;
      final bool isAtOtp = location == AppRoutesPath.otpPage;
      final bool isAtSplash = location == AppRoutesPath.splashPage;
      final bool isAtsavedaddress = location == AppRoutesPath.savedAddressPage;
      final bool isAtTermsPage = location == AppRoutesPath.termsPage;
      final bool isAtLocationPage = location == AppRoutesPath.locationPage;
      final bool isAtSelectVehicleScreen =
          location == AppRoutesPath.selectVehicleScreen;

      if (isAtSplash) return null;

      // 1. If logged in, move away from Auth pages
      if (isLoggedIn) {
        return (isAtLogin || isAtOtp) ? AppRoutesPath.homepage : null;
      }

      // 2. THE FIX: If NOT logged in, allow them to stay on Login OR OTP.
      // This prevents the router from kicking the user back to Login while they are entering OTP.
      if (!isAtLogin && !isAtOtp) {
        return AppRoutesPath.loginPage;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutesName.splashPageName,
        path: AppRoutesPath.splashPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const SplashScreen()),
      ),
      GoRoute(
        name: AppRoutesName.loginPageName,
        path: AppRoutesPath.loginPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const LoginPage()),
      ),
      GoRoute(
        name: AppRoutesName.registerPageName,
        path: AppRoutesPath.registerPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const RegisterScreen()),
      ),

      GoRoute(
        name: AppRoutesName.otpPageName,
        path: AppRoutesPath.otpPage,
        pageBuilder: (context, state) {
          final phone = state.extra as String? ?? '';
          return PageTransition(child: OtpPage(phoneNumber: phone));
        },
      ),
      GoRoute(
        name: AppRoutesName.homePageName,
        path: AppRoutesPath.homepage,
        pageBuilder: (context, state) =>
            PageTransition(child: const HomeScreen()),
      ),

      GoRoute(
        name: AppRoutesName.profilePageName,
        path: AppRoutesPath.profilepage,
        pageBuilder: (context, state) =>
            PageTransition(child: const ProfileScreen()),
      ),
      GoRoute(
        name: AppRoutesName.savedAddressPageName,
        path: AppRoutesPath.savedAddressPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const SavedAddressPage()),
      ),
      GoRoute(
        name: AppRoutesName.termsPageName,
        path: AppRoutesPath.termsPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const TermsPage()),
      ),
      GoRoute(
        name: AppRoutesName.locationPageName,
        path: AppRoutesPath.locationPage,
        pageBuilder: (context, state) =>
            PageTransition(child: const LocationPage()),
      ),
      GoRoute(
        name: AppRoutesName.selectVehicleScreen,
        path: AppRoutesPath.selectVehicleScreen,
        pageBuilder: (context, state) =>
            PageTransition(child: const SelectVehicleScreen()),
      ),
      GoRoute(
        name: AppRoutesName.helpSupport,
        path: AppRoutesPath.helpsupportpage,
        pageBuilder: (context, state) =>
            PageTransition(child: const HelpSupportPage()),
      ),
      GoRoute(
        name: AppRoutesName.gstPagename,
        path: AppRoutesPath.gstpage,
        pageBuilder: (context, state) =>
            PageTransition(child: const AddGstinScreen()),
      ),

      GoRoute(
        name: AppRoutesName.paysuccessPagename,
        path: AppRoutesPath.paySuccesspage,
        pageBuilder: (context, state) =>
            PageTransition(child: const PaySuccessfulScreen()),
      ),

      GoRoute(
        name: AppRoutesName.addAddressPageName,
        path: AppRoutesPath.addAddressScreen,
        pageBuilder: (context, state) =>
            PageTransition(child: const AddAddressScreen()),
      ),

      GoRoute(
        name: AppRoutesName.editAddressPageName,
        path: AppRoutesPath.editAddressPage,
        pageBuilder: (context, state) {
          final address = state.extra as AddressModel;
          return PageTransition(child: EditAddressPage(address: address));
        },
      ),
      

      GoRoute(
        name: AppRoutesName.reviewBookingScreenPageName, // 'reviewBookingScreen'
        path: AppRoutesPath.reviewBookingScreenpage,     // '/reviewBookingScreen'
        pageBuilder: (context, state) =>
            PageTransition(child: const ReviewBookingScreen()),
      ),
      // GoRoute(
      //   name: AppRoutesName.paymentScreenPageName,
      //   path: AppRoutesPath.paymentScreen,
      //   pageBuilder: (context, state) =>
      //       PageTransition(child: const PaymentScreen()),
      // ),
      GoRoute(
        name: AppRoutesName.contactDetailsPagename,
        path: AppRoutesPath.contactDetailspage,
        pageBuilder: (context, state) =>
            PageTransition(child: const Contactdetails()),
      ),

      GoRoute(
        name: AppRoutesName.tripDetailsPageName,
        path: AppRoutesPath.tripDetailsPath,
        pageBuilder: (context, state) =>
            PageTransition(child: TripDetailsScreen(tripId: "CRN1495224392")),
      ),

      GoRoute(
        name: AppRoutesName.trackorderPageName,
        path: AppRoutesPath.trackOrder,
        pageBuilder: (context, state) =>
            PageTransition(child: const TrackOrder()),
      ),

      // GoRoute(
      //   name: AppRoutesName.ordersHistoryScreen,
      //   path: AppRoutesPath.ordersHistoryScreen,
      //   pageBuilder: (context, state) =>
      //       PageTransition(child: const OrdersHistoryScreen()),
      // ),

      GoRoute(
        name: AppRoutesName.ordersHistoryScreen,
        path: AppRoutesPath.ordersHistoryScreen,
        pageBuilder: (context, state) =>
            PageTransition(child: const OrdersScreen()),
      ),

      //This is routing for above tripdetails page
      // context.pushNamed(
      //   AppRoutesName.tripDetailsPageName,
      //   pathParameters: {'tripId': 'CRN1495224392'},
      // );

      //// 🔥 SHELL ROUTE (Bottom Navbar Wrapper)
      // ShellRoute(
      //   builder: (context, state, child) {
      //     return DashboardBase(child: child);
      //   },
      //   routes: [

      //     GoRoute(
      //       path: '/home',
      //       builder: (_, __) => const HomeScreen(),
      //     ),

      //     GoRoute(
      //       path: '/orders',
      //       builder: (_, __) => const OrderScreen(),
      //     ),

      //     GoRoute(
      //       path: '/categories',
      //       builder: (_, __) => const CategoriesScreen(),
      //     ),

      //     GoRoute(
      //       path: '/print',
      //       builder: (_, __) => const PrintScreen(),
      //     ),
      //   ],
      // ),
    ],
  );
});
