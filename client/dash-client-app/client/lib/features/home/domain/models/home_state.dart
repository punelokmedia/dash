
// ── Home State ────────────────────────────────────────────
import 'package:dash_logistics/features/home/domain/models/banner_model.dart';
import 'package:dash_logistics/features/home/domain/models/past_order_model.dart';
import 'package:dash_logistics/features/home/domain/models/rewards_model.dart';
import 'package:dash_logistics/features/home/domain/models/service_model.dart';

class HomeState {
  final bool isLoading;
  final String? errorMessage;
  final List<BannerModel> banners;
  final List<ServiceModel> services;
  final List<PastOrderModel> pastOrders;
  final RewardsModel? rewards;
  final String userLocation;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.banners = const [],
    this.services = const [],
    this.pastOrders = const [],
    this.rewards,
    this.userLocation = '',
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<BannerModel>? banners,
    List<ServiceModel>? services,
    List<PastOrderModel>? pastOrders,
    RewardsModel? rewards,
    String? userLocation,
  }) =>
      HomeState(
        isLoading:    isLoading    ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        banners:      banners      ?? this.banners,
        services:     services     ?? this.services,
        pastOrders:   pastOrders   ?? this.pastOrders,
        rewards:      rewards      ?? this.rewards,
        userLocation: userLocation ?? this.userLocation,
      );

  HomeState clearError() => HomeState(
        isLoading:    isLoading,
        banners:      banners,
        services:     services,
        pastOrders:   pastOrders,
        rewards:      rewards,
        userLocation: userLocation,
      );
}