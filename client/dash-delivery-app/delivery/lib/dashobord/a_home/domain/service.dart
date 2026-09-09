class HomeData {
  final String driverName;
  final String location;
  final String avatarUrl;
  final int completedTrips;
  final int loginHours;
  final double completionScore; // 0.0 – 1.0
  final double totalRewards;
  final double dashWallet;
  final CurrentOrder? currentOrder;
  final double todayEarning;
  final List<BannerItem> banners;

  const HomeData({
    required this.driverName,
    required this.location,
    required this.avatarUrl,
    required this.completedTrips,
    required this.loginHours,
    required this.completionScore,
    required this.totalRewards,
    required this.dashWallet,
    this.currentOrder,
    required this.todayEarning,
    required this.banners,
  });
}

class CurrentOrder {
  final String pickupAddress;
  final String orderStatus;
  const CurrentOrder({required this.pickupAddress, required this.orderStatus});
}

enum BannerLayout { textLeft, textRight }

class BannerItem {
  final String title;
  final String subtitle;
  final String ctaLabel;
  final String imagePath;
  final BannerLayout layout;
  final bool showLogo; // show Dash logo or not

  const BannerItem({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.imagePath,
    this.layout = BannerLayout.textLeft,
    this.showLogo = false,
  });
}
