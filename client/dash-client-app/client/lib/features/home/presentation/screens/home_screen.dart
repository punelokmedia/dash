import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/home/presentation/widgets/home_app_bar.dart';
import 'package:dash_logistics/features/home/presentation/widgets/home_banner_carousel.dart';
import 'package:dash_logistics/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:dash_logistics/features/home/presentation/widgets/home_past_orders.dart';
import 'package:dash_logistics/features/home/presentation/widgets/home_reward_service.dart';
import 'package:dash_logistics/features/home/presentation/widgets/service_bottom_sheet.dart';
import 'package:dash_logistics/features/home/shared/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final navIndex = useState(0);

    useEffect(() {
      Future.microtask(() => controller.loadHome());
      return null;
    }, []);

    ref.listen(homeControllerProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
        controller.clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.lemon,
      // ✅ extendBody: false — body fills exactly between appbar and navbar
      extendBody: false,
      appBar: HomeAppBar(
        location: state.userLocation.isEmpty
            ? 'Clover Hill Plaza,'
            : state.userLocation,
        onLocationTap: () {},
        onNotificationTap: () {},
        onProfileTap: () => context.pushNamed(AppRoutesName.profilePageName),
      ),
      // ✅ Navbar in body Column — avoids Scaffold.bottomNavigationBar
      //    safe-area handling inconsistency on web vs mobile
      body: Column(
        children: [
          // ── White scrollable body ─────────────────────────
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32.r),
                bottomRight: Radius.circular(32.r),
              ),
              child: ColoredBox(
                color: Colors.white,
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                        ),
                      )
                    : RefreshIndicator(
                        color: const Color(0xFF4CAF50),
                        onRefresh: controller.loadHome,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 14.h),
                              HomeBannerCarousel(banners: state.banners),
                              SizedBox(height: 16.h),
                              HomeRewardsBanner(rewards: state.rewards),
                              SizedBox(height: 20.h),
                              HomeServicesGrid(
                                services: state.services,
                                onServiceTap: (service) =>
                                    showServiceSheet(context, service.name),
                              ),
                              SizedBox(height: 32.h),
                              HomePastOrders(
                                orders: state.pastOrders,
                                onOrderAgain: (_) {},
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.lemongreen,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: HomeBottomNavBar(
          currentIndex: navIndex.value,
          onTap: (i) {
            navIndex.value = i;

            switch (i) {
              case 0:
                context.goNamed(AppRoutesName.homePageName);
                break;

              case 1:
                context.goNamed(AppRoutesName.ordersHistoryScreen);
                break;

              case 2:
                break;

              case 3:
                break;
            }
          },
        ),
      ),
    );
  }
}
