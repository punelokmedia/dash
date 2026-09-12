import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/features/dashboard/orders_history_pages/presentation/pages/history_orders_pages.dart';
import 'package:dash_logistics/features/dashboard/orders_history_pages/presentation/pages/ongoing_orders_page.dart';
import 'package:dash_logistics/features/dashboard/orders_history_pages/presentation/widgets/toggle_button.dart';
import 'package:dash_logistics/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:dash_logistics/features/home/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrdersScreen extends HookConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOngoing = useState(true);
    final navIndex = useState(1);

    return Scaffold(
      backgroundColor: Colors.white,

      // ── App Bar ───────────────────────────────────────────────────────
      appBar: HomeAppBar(
        location: 'Clover Hill Plaza',
        onLocationTap: () {},
        onNotificationTap: () {},
        onProfileTap: () => context.pushNamed(AppRoutesName.profilePageName),
      ),

      // ── Body ──────────────────────────────────────────────────────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── "Orders" title ────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(top: 14.h, bottom: 14.h),
            child: Text(
              "Orders",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.color159,
                fontFamily: AppTextStyles.fontFamilyRoboto,
              ),
            ),
          ),

          // ── Main area: white card + green strip ───────────────────────
          Expanded(
            child: Stack(
              children: [
                // ── Green bottom strip — fills behind nav ─────────────
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(height: 40.h, color: AppColors.lemongreen),
                ),

                // ── White floating card — sits above green, matches home
                Positioned(
                  top: 0,
                  left: 0.w,
                  right: 0.w,
                  // bottom: 20.h keeps the card base hovering above nav
                  // same visual gap as home screen "Past order" card bottom
                  bottom: 0.h,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.13),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28.r),
                      child: Column(
                        children: [
                          // ── Toggle switch ───────────────────────────
                          ToggleSwitch(
                            isOngoing: isOngoing.value,
                            onToggle: (val) => isOngoing.value = val,
                          ),

                          SizedBox(height: 4.h),

                          // ── Order list ──────────────────────────────
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              switchInCurve: Curves.easeInOut,
                              switchOutCurve: Curves.easeInOut,
                              child: isOngoing.value
                                  ? const OngoingOrders(
                                      key: ValueKey('ongoing'),
                                    )
                                  : const HistoryOrders(
                                      key: ValueKey('history'),
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
        ],
      ),

      // ── Bottom Nav — same green background as home screen ─────────────
      bottomNavigationBar: Container(
        color: AppColors.lemongreen,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
