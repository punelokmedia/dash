import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widget/location_card.dart';
import '../widget/service_card.dart';
import '../widget/gst_card.dart';
import '../widget/total_amount_section.dart';
import '../widget/vehicals_card.dart';

// ✅ Must be ConsumerWidget (not HookConsumerWidget) so TotalAmountSection
//    can access paymentControllerProvider via its own ConsumerState
class ReviewBookingScreen extends ConsumerWidget {
  const ReviewBookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.lemongreen,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color:  AppColors.white,
            size:   20.sp,
          ),
        ),
        title: Text(
          "Review Booking",
          style: TextStyle(
            color:      AppColors.white,
            fontSize:   17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Pickup & Drop locations ───────────────────
            const LocationCard(),
            SizedBox(height: 14.h),

            // ── Vehicle info ──────────────────────────────
            const VehicleCard(),
            SizedBox(height: 14.h),

            // ── Add Services ──────────────────────────────
            const ServiceCard(),
            SizedBox(height: 14.h),

            // ── GST Details ───────────────────────────────
            const GstCard(),
            SizedBox(height: 14.h),

            // ── Total + Next (Razorpay) ───────────────────
            const TotalAmountSection(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}