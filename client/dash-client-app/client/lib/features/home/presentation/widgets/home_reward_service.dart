import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/features/home/domain/models/rewards_model.dart';
import 'package:dash_logistics/features/home/domain/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// ════════════════════════════════════════════════════════════════════════════
// Rewards Banner
// ════════════════════════════════════════════════════════════════════════════
class HomeRewardsBanner extends StatelessWidget {
  final RewardsModel? rewards;
  const HomeRewardsBanner({super.key, this.rewards});

  @override
  Widget build(BuildContext context) {
    final coins   = rewards?.coins ?? 0;
    final message = rewards?.message ?? 'Earn 2 coins every ₹100 spent';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color:        Colors.black,
          borderRadius: BorderRadius.circular(14.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width:  40.w,
              height: 40.w,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: Image.asset(
                  'assets/Icons/home/reward_icon.png',
                  width:  40.w,
                  height: 40.w,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                    size:  22.r,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Discover Dash Rewards',
                    style: TextStyle(
                      color:      AppColors.lemon,
                      fontSize:   20.sp,
                      fontFamily: AppTextStyles.fontFamilyRoboto,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    coins > 0 ? 'You have $coins coins' : message,
                    style: TextStyle(
                      color:      AppColors.white,
                      fontFamily: AppTextStyles.fontFamilyRoboto,
                      fontSize:   16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade600, size: 14.r),
          ],
        ),
      ),
    );
  }
}


// ════════════════════════════════════════════════════════════════════════════
// Static home-screen service entry — carries both the ServiceModel fields
// and an explicit local asset path for the vehicle image.
// ════════════════════════════════════════════════════════════════════════════
class _HomeServiceEntry {
  final ServiceModel model;
  final String       imageAsset; // local asset for the floating vehicle image
 
  const _HomeServiceEntry({required this.model, required this.imageAsset});
}
 
// Always-visible static cards.
// The bottom sheet handles the real API fetch when the user taps.
final _staticEntries = [
  _HomeServiceEntry(
    model:      ServiceModel(id: '1', name: 'Truck',     type: 'WITHIN_CITY'),
    imageAsset: 'assets/Images/home/truck.png',
  ),
  _HomeServiceEntry(
    model:      ServiceModel(id: '2', name: '2 Wheeler', type: 'OUTSTATION'),
    imageAsset: 'assets/Images/home/scooter.png',
  ),
];
 
// ════════════════════════════════════════════════════════════════════════════
// Services Grid
// ════════════════════════════════════════════════════════════════════════════
class HomeServicesGrid extends StatelessWidget {
  /// Accepted for API compatibility but ignored — static cards are always shown.
  final List<ServiceModel>          services;
  final void Function(ServiceModel) onServiceTap;
 
  const HomeServicesGrid({
    super.key,
    required this.services,
    required this.onServiceTap,
  });
 
  @override
  Widget build(BuildContext context) {
    // How far the vehicle image floats above the green card
    final double imageOverhang = 62.h;
 
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Our Services',
            style: TextStyle(
              fontSize:   16.sp,
              fontWeight: FontWeight.w700,
              color:      AppColors.black,
              fontFamily: AppTextStyles.fontFamilyRoboto,
            ),
          ),
 
          // ── Top gap = overhang so images have room above the cards ────
          SizedBox(height: imageOverhang + 8.h),
 
          // ── Cards row ─────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _staticEntries.map((entry) {
              final isLast = entry == _staticEntries.last;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 12.w),
                  child: _ServiceCard(
                    entry:         entry,
                    onTap:         () => onServiceTap(entry.model),
                    imageOverhang: imageOverhang,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
 
// ── Single card: green pill + vehicle image floating above ────────────────────
class _ServiceCard extends StatelessWidget {
  final _HomeServiceEntry entry;
  final VoidCallback       onTap;
  final double             imageOverhang;
 
  const _ServiceCard({
    required this.entry,
    required this.onTap,
    required this.imageOverhang,
  });
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:    onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none, // ✅ image can overflow above card
        children: [
 
          // ── Green card ────────────────────────────────────────────────
          Container(
            height: 87.h,
            width:  double.infinity,
            decoration: BoxDecoration(
              color:        AppColors.lemon,
              borderRadius: BorderRadius.circular(14.r),
            ),
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:       MainAxisSize.min,
              children: [
                Text(
                  entry.model.name,
                  style: TextStyle(
                    fontSize:   16.sp,
                    fontWeight: FontWeight.w600,
                    color:      AppColors.white,
                    fontFamily: AppTextStyles.fontFamilyRoboto,
                  ),
                ),
                SizedBox(height: 4.h),
                Icon(
                  Icons.arrow_forward,
                  size:  24.sp,
                  color: Colors.white,
                ),
              ],
            ),
          ),
 
          // ── Vehicle image — floats above the card ─────────────────────
          Positioned(
            top:   -imageOverhang, // negative = above card top edge
            left:  0,
            right: 0,
            child: IgnorePointer(
              child: Image.asset(
                entry.imageAsset,
                height:    imageOverhang + 20.h,
                fit:       BoxFit.contain,
                alignment: Alignment.bottomCenter,
                errorBuilder: (_, _, _) => SizedBox(
                  height: imageOverhang + 20.h,
                  child: Icon(
                    Icons.local_shipping_outlined,
                    size:  48.r,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
 
        ],
      ),
    );
  }
}