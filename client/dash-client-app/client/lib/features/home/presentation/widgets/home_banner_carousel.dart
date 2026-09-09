import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/home/domain/models/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeBannerCarousel extends HookWidget {
  final List<BannerModel> banners;
  const HomeBannerCarousel({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    final pageCtrl    = usePageController();
    final currentPage = useState(0);

    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // ── Banner pages ──────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: AspectRatio(
            aspectRatio: 387 / 185, // exact Figma ratio — no fixed px height
            child: PageView.builder(
              controller:    pageCtrl,
              onPageChanged: (i) => currentPage.value = i,
              itemCount:     banners.length,
              itemBuilder:   (_, i) => _BannerCard(banner: banners[i]),
            ),
          ),
        ),

        SizedBox(height: 8.h),

        // ── Dot indicator ─────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width:  currentPage.value == i ? 18.w : 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: currentPage.value == i
                    ? AppColors.lemon
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Single card: pure image, rounded corners, no text/overlay/color ───────────
class _BannerCard extends StatelessWidget {
  final BannerModel banner;
  const _BannerCard({required this.banner});

  bool get _isNetwork =>
      banner.imageUrl.startsWith('http://') ||
      banner.imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: _isNetwork
          ? Image.network(
              banner.imageUrl,
              // BoxFit.fill stretches to fill the AspectRatio box completely
              // with no cropping — the image itself carries all the design
              fit:            BoxFit.fill,
              alignment:      Alignment.center,
              errorBuilder:   (_, _, _) => _placeholder(),
              loadingBuilder: (_, child, p) =>
                  p == null ? child : _placeholder(),
            )
          : Image.asset(
              banner.imageUrl,
              fit:          BoxFit.fill,   // fills the box, no crop, no padding
              alignment:    Alignment.center,
              errorBuilder: (_, _, _) => _placeholder(),
            ),
    );
  }

  Widget _placeholder() => Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Icon(Icons.image_outlined,
              color: Colors.grey.shade400, size: 40),
        ),
      );
}