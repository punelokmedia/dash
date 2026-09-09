// ignore_for_file: depend_on_referenced_packages, unused_field, unused_import

import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/home/domain/models/banner_model.dart';
import 'package:dash_logistics/features/home/domain/models/home_state.dart';
import 'package:dash_logistics/features/home/domain/models/past_order_model.dart';
import 'package:dash_logistics/features/home/domain/models/rewards_model.dart';
import 'package:dash_logistics/features/home/domain/models/service_model.dart';
import 'package:dash_logistics/features/home/infra/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class HomeController extends StateNotifier<HomeState> {
  final HomeRepository _repo;

  HomeController(this._repo) : super(const HomeState());

  /// Loads static data now.
  /// When API is ready: uncomment Future.wait block & remove static block.
  Future<void> loadHome() async {
    state = state.copyWith(isLoading: true);

    try {
      final services = await _repo.fetchServices();
      state = state.copyWith(services: services);
    } catch (e) {
      // ✅ fallback to static if API fails
      state = state.copyWith(
        services: [
          ServiceModel(id: '1', name: 'Within City', type: 'WITHIN_CITY'),
          ServiceModel(id: '2', name: 'Outstation', type: 'OUTSTATION'),
        ],
      );
    }

    // ── STATIC DATA (remove block when API is ready) ───────────
    await Future.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(
      isLoading: false,
      userLocation: 'Clover Hill Plaza,',
      banners: [
        BannerModel(
          id: '1',
          imageUrl: 'assets/Images/home/carousel_img.png',
          title: 'Secure Packing. Safe Delivery.',
          subtitle: 'Know more',
          bgColor: 0xFFC0D72F,
        ),
        BannerModel(
          id: '2',
          imageUrl: 'assets/Images/home/carousel_img.png',
          title: 'Fast & Reliable Logistics.',
          subtitle: 'Book now',
          bgColor: 0xFFC0D72F,
        ),
        BannerModel(
          id: '3',
          imageUrl: 'assets/Images/home/carousel_img.png',
          title: 'Move Anything, Anywhere.',
          subtitle: 'Get quote',
          bgColor: 0xFFC0D72F,
        ),
      ],

      pastOrders: [
        PastOrderModel(
          id: '1',
          serviceType: '2 Wheeler Delivery',
          date: '19 Jul 2025, 01:31 PM',
          amount: 30,
          imageUrl: 'assets/Images/home/scooter.png',
        ),
      ],
      rewards: RewardsModel(coins: 0, message: 'Earn 2 coins every 100 spent'),
    );
    // ──────────────────────────────────────────────────────────
  }

  void updateLocation(String location) =>
      state = state.copyWith(userLocation: location);

  void clearError() => state = state.clearError();
}
