// ── Fake API ──────────────────────────────────────────────────────────────────
import 'package:delivary_partner/dashobord/a_home/domain/service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeNotifier extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() => ref.read(_homeApiProvider).fetchHome();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(_homeApiProvider).fetchHome(),
    );
  }
}

class HomeApi {
  Future<HomeData> fetchHome() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return const HomeData(
      driverName: 'Manoj',
      location: 'Pune, Maharashtra',
      avatarUrl: '',
      completedTrips: 12,
      loginHours: 4,
      completionScore: 0.45,
      totalRewards: 5020,
      dashWallet: 3256,
      currentOrder: CurrentOrder(
        pickupAddress: 'Karve Road, Kothrud, Pune 411004',
        orderStatus: 'Pick up',
      ),
      todayEarning: 50,
      banners: [
        // ← just pass it like any other field
        BannerItem(
          title: 'Fast Safe &\nAlways on Time',
          subtitle:
              'Join our delivery partner network\n& start earning on your schedule.',
          ctaLabel: 'Start Now',
          imagePath: 'assets/images/png/banner_1.png',
          layout: BannerLayout.textLeft,
          showLogo: false,
        ),
        BannerItem(
          title: 'Deliver Anything,\nAnytime',
          subtitle: 'Flexible hours, fast payouts, and\nmore orders near you.',
          ctaLabel: 'Join Now',
          imagePath: 'assets/images/png/banner_2.png',
          layout: BannerLayout.textRight,
          showLogo: true,
        ),
        BannerItem(
          title: 'Earn More\nEvery Ride',
          subtitle:
              'Top partners unlock bonuses and\npriority order assignments.',
          ctaLabel: 'Learn More',
          imagePath: 'assets/images/png/banner_3.png',
          layout: BannerLayout.textRight,
          showLogo: true,
        ),
      ],
    );
  }
}

final _homeApiProvider = Provider<HomeApi>((_) => HomeApi());
