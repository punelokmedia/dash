import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:delivary_partner/dashobord/a_home/domain/service.dart';
import 'package:delivary_partner/dashobord/a_home/shared/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const _kGreen = Color(0xFF8BBB22);
const _kGreenDark = Color(0xFF7AAD18);
const _kOrange = Color(0xFFFF6B35);
const _kBg = Color(0xFFF5F5F5);
const _kCard = Colors.white;
const _kTextDark = Color(0xFF1A1A1A);
const _kTextMedium = Color(0xFF555555);
const _kTextLight = Color(0xFF999999);

class homePage extends HookConsumerWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final homeAsync = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: _kBg,
      body: homeAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: _kGreen)),
        error: (e, _) => _ErrorBody(
          message: e.toString(),
          onRetry: () => ref.read(homeProvider.notifier).refresh(),
        ),
        data: (data) => _HomeBody(data: data),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────
class _HomeBody extends HookWidget {
  final HomeData data;
  const _HomeBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final bannerIndex = useState(0);
    final pageController = usePageController();

    return Column(
      children: [
        SizedBox(height: 10.h),
        _Header(data: data),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
          child: _SearchBar(),
        ),

        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Green header ──────────────────────────────────────────

              // ── Performance ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  child: _PerformanceCard(data: data),
                ),
              ),

              // ── Rewards ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: _RewardsCard(data: data),
                ),
              ),

              // ── Banner carousel ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: _BannerCarousel(
                    banners: data.banners,
                    currentIndex: bannerIndex,
                    controller: pageController,
                  ),
                ),
              ),

              // ── Current order ─────────────────────────────────────────
              if (data.currentOrder != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                    child: _CurrentOrderCard(order: data.currentOrder!),
                  ),
                ),

              // ── Promo text ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                  child: const _PromoText(),
                ),
              ),

              // ── Today's earning ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: _EarningCard(earning: data.todayEarning),
                ),
              ),

              // ── Bottom banner ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
                  child: const _BottomBanner(),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 80.h)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final HomeData data;
  const _Header({required this.data});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, top + 12.h, 16.w, 18.h),
      child: Row(
        mainAxisAlignment: .start,
        children: [
          // Avatar
          Container(
            width: 44.w,
            height: 46.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Color.fromRGBO(94, 103, 105, 1),
                width: 1.r,
              ),
            ),
            child: ClipOval(
              child: data.avatarUrl.isNotEmpty
                  ? Image.network(data.avatarUrl, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        data.driverName[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: _kGreen,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(width: 13.w),

          // Name + location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello , ',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: data.driverName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    SizedBox(width: 2.w),
                    Text(
                      data.location,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Color.fromRGBO(159, 177, 51, 1),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bell
          _HeaderIcon(icon: Icons.notifications_outlined),
          SizedBox(width: 14.w),
          // Headset
          _HeaderIcon(icon: Icons.headset_outlined),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 35.sp, color: AppColors.commonText);
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.17),
            blurRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 20.sp, color: _kTextLight),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 14.sp, color: _kTextLight),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 14.sp, color: _kTextDark),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Performance card ──────────────────────────────────────────────────────────
class _PerformanceCard extends StatelessWidget {
  final HomeData data;
  const _PerformanceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(title: 'My Performance', onTap: () {}),
          SizedBox(height: 8.h),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.speed_rounded,
                  iconColor: Color.fromRGBO(117, 117, 117, 1),
                  label: 'My Trips',
                  value: '${data.completedTrips}',
                  sub: 'Completed\nScore',
                ),
              ),
              Container(
                width: 1.5,
                height: 40.h,
                color: const Color.fromARGB(255, 187, 185, 185),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.access_time_rounded,
                  iconColor: Color.fromRGBO(117, 117, 117, 1),
                  label: 'Login Hours',
                  value: '${data.loginHours.toString().padLeft(2, '0')} hrs',
                  sub: '',
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Progress bar hint
          SizedBox(
            height: 36.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.commonButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                elevation: 0,
              ),
              onPressed: () {},
              child: Text(
                'Complete more orders to see completion score',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(icon, size: 24.sp, color: iconColor),
              SizedBox(width: 5.w),

              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.commonText,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sub.isNotEmpty)
                    Text(
                      sub,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: _kTextLight,
                        height: 1,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Rewards card ──────────────────────────────────────────────────────────────
class _RewardsCard extends StatelessWidget {
  final HomeData data;
  const _RewardsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112.h,

      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 0.h),
            child: _CardHeader(title: 'Dash Rewards', onTap: () {}),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                Expanded(
                  child: _RewardStat(
                    label: 'Total Rewards',
                    value:
                        '${data.totalRewards.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}/-',
                  ),
                ),
                Container(
                  width: 1,
                  height: 38.h,
                  color: Color.fromRGBO(169, 169, 169, 1),
                ),
                Expanded(
                  child: _RewardStat(
                    label: 'Dash Wallets',
                    value:
                        '${data.dashWallet.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}/-',
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

class _RewardStat extends StatelessWidget {
  final String label;
  final String value;
  const _RewardStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: const Color.fromARGB(255, 114, 118, 119),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Banner carousel ───────────────────────────────────────────────────────────
class _BannerCarousel extends HookWidget {
  final List<BannerItem> banners;
  final ValueNotifier<int> currentIndex;
  final PageController controller;

  const _BannerCarousel({
    required this.banners,
    required this.currentIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Auto-scroll
    useEffect(() {
      final timer = Stream.periodic(const Duration(seconds: 3));
      final sub = timer.listen((_) {
        if (!controller.hasClients) return;
        final next = (currentIndex.value + 1) % banners.length;
        controller.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
      return sub.cancel;
    }, []);

    return Column(
      children: [
        SizedBox(
          height: 130.h,
          child: PageView.builder(
            controller: controller,
            onPageChanged: (i) => currentIndex.value = i,
            itemCount: banners.length,
            itemBuilder: (_, i) => _BannerTile(item: banners[i]),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (i) {
            final active = i == currentIndex.value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: active ? 18.w : 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: active ? _kGreen : _kTextLight.withOpacity(0.4),
                borderRadius: BorderRadius.circular(3.r),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerTile extends StatelessWidget {
  final BannerItem item;
  const _BannerTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isTextLeft = item.layout == BannerLayout.textLeft;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.commonButton, // olive green border
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: isTextLeft
              ? [_textSection(context), _imageSection(isTextLeft)]
              : [
                  _imageSection(isTextLeft),
                  _treeimageSection(isTextLeft), // ← added
                  _textSection(context),
                ],
        ),
      ),
    );
  }

  // ── Text + CTA side ──────────────────────────────────────────────────────
  Widget _textSection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 4.h, 10.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Optional Dash logo
            if (item.showLogo) ...[
              Image.asset('assets/images/png/dash_logo.png', height: 20.h),
              SizedBox(height: 2.h),
            ],

            // Title
            Text(
              item.title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                // green for textLeft style, orange for textRight style
                color: item.layout == BannerLayout.textLeft
                    ? const Color(0xFF9FB133) // olive green (Image 1)
                    : const Color(0xFFE07B2A), // orange (Image 2)
                height: 1,
              ),
            ),
            SizedBox(height: 2.h),

            // Subtitle
            Text(
              item.subtitle,
              style: TextStyle(
                fontSize: 8.sp,
                color: const Color(0xFF8F9394),
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            SizedBox(height: 6.h),

            // CTA button
            Container(
              height: 20.h,
              width: 64.w,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: AppColors.commonButton,
                borderRadius: BorderRadius.circular(20.r),
              ),
              alignment: Alignment.center,
              child: Text(
                item.ctaLabel,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Illustration side ────────────────────────────────────────────────────
  Widget _imageSection(bool isTextLeft) {
    return SizedBox(
      width: 140.w,
      height: 90.h,
      child: ClipRRect(
        borderRadius: isTextLeft
            ? BorderRadius.only(
                topRight: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(14.r),
                bottomLeft: Radius.circular(14.r),
              ),
        child: Image.asset(
          item.imagePath,
          fit: BoxFit.contain,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _treeimageSection(bool isTextLeft) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.w, 40.h, 40.w, 0),
      child: SizedBox(
        // height: 35.h,
        child: Image.asset(
          'assets/images/png/tree.png',
          fit: BoxFit.contain,
          height: 34.h,
        ),
      ),
    );
  }
}

// ── Current order card ────────────────────────────────────────────────────────
class _CurrentOrderCard extends StatelessWidget {
  final CurrentOrder order;
  const _CurrentOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 99.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.17),
            blurRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 4, 20.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ── Title + bike icon ────────────────────────────────
                Row(
                  children: [
                    Text(
                      'Current Order',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.commonText,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // ── Bike icon in green tint ──────────────────────
                    Icon(
                      size: 26.sp,
                      Icons.two_wheeler_rounded,
                      color: AppColors.commonButton,
                    ),
                  ],
                ),

                // ── Chevron ──────────────────────────────────────────
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 30.sp,
                    color: _kTextLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/png/location.png',
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 6.w),
                Text(
                  order.orderStatus,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
            Text(
              order.pickupAddress,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color.fromRGBO(94, 103, 105, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Promo text ────────────────────────────────────────────────────────────────
class _PromoText extends StatelessWidget {
  const _PromoText();

  // Cooper Black text style helper
  static TextStyle _cooper(Color color, double size) => TextStyle(
    fontFamily: 'CooperBlack',
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.4,
    letterSpacing: 2.4,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Wavy green blobs background ──────────────────────────
        Positioned(
          top: -10,
          left: -30,
          child: _GreenBlob(width: 160.w, height: 100.h),
        ),
        Positioned(
          bottom: -10,
          right: -20,
          child: _GreenBlob(width: 140.w, height: 90.h),
        ),

        // ── Text on top ───────────────────────────────────────────
        RichText(
          text: TextSpan(
            children: [
              // "Bass Order Karo -\nBaki "
              TextSpan(
                text: 'Bass Order Karo -\nBaki ',
                style: _cooper(AppColors.commonText, 32.sp),
              ),

              // "Da" — black
              TextSpan(text: 'Da', style: _cooper(_kTextDark, 32.sp)),

              // "s" — orange
              TextSpan(text: 's', style: _cooper(_kOrange, 32.sp)),

              // "h" — black
              TextSpan(text: 'h', style: _cooper(_kTextDark, 32.sp)),

              // " Sambhal Lega"
              TextSpan(
                text: ' Sambhal Lega',
                style: _cooper(AppColors.commonText, 32.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Wavy green blob painter ───────────────────────────────────────────────────
class _GreenBlob extends StatelessWidget {
  final double width;
  final double height;
  const _GreenBlob({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(width, height), painter: _BlobPainter());
  }
}

class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFFE8F5C8) // light green tint
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.1,
      size.width * 0.6,
      size.height * 0.0,
      size.width,
      size.height * 0.3,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width * 0.4,
      size.height * 1.0,
      0,
      size.height * 0.8,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Today's earning card ──────────────────────────────────────────────────────
class _EarningCard extends StatelessWidget {
  final double earning;
  const _EarningCard({required this.earning});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.17),
            blurRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      height: 58.h,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 4.h),
        child: Row(
          children: [
            SizedBox(width: 12.w),
            Image.asset('assets/images/png/money.png', fit: BoxFit.cover),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                "Today's Earning",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(117, 117, 117, 1),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  '₹',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),
                ),

                Text(
                  ' ${earning.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: _kGreen,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5.w),
            Icon(Icons.chevron_right_rounded, size: 20.sp, color: _kTextLight),
          ],
        ),
      ),
    );
  }
}

// ── Bottom promo banner ───────────────────────────────────────────────────────
class _BottomBanner extends StatelessWidget {
  const _BottomBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 174.h,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.commonButton, // olive green border
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Container(
        height: 152.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 0.w, 0.h),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/png/dash_logo.png',
                    height: 28.h,
                    fit: BoxFit.contain,
                  ),

                  // Dash logo text
                  SizedBox(height: 6.h),
                  // ── "Delivery Fast" orange + "Earn More" dark ────────────────
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Delivery Fast\n',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFE8A445), // orange
                            height: 1,
                          ),
                        ),
                        TextSpan(
                          text: 'Earn More',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1B2A3B), // dark navy
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // ── Subtitle ─────────────────────────────────────────────────
                  Text(
                    'Join our delivery partner network\n& start earning on your schedule.',
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Color.fromRGBO(7, 30, 61, 1), // grey
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // ── Get Started button ────────────────────────────────────────
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 20.h,
                      width: 72.w,
                      decoration: BoxDecoration(
                        color: AppColors.commonButton, // olive green
                        borderRadius: BorderRadius.circular(30.r), // full pill
                      ),
                      child: Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Illustration placeholder
            SizedBox(width: 10.w),
            Image.asset(
              width: 168.w,
              height: 93.41.h,
              'assets/images/png/exchange.png',
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195.h,
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _CardHeader({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.commonText,
              letterSpacing: 1,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.chevron_right_rounded,
              size: 30.sp,
              color: _kTextLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────
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
            Icon(Icons.error_outline_rounded, size: 48.sp, color: _kGreen),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: _kTextMedium),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _kGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
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
