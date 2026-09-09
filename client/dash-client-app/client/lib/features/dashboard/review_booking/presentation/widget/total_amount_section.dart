import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/dashboard/review_booking/domain/state/payment_state.dart';
import 'package:dash_logistics/features/dashboard/review_booking/shared/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

// ── Replace with your actual Razorpay test key ────────────────────────────────
const _razorpayKeyId = 'rzp_test_XXXXXXXXXXXXXXXX';

// ── Static test values (swap with real data from booking state later) ─────────
const _testOrderId    = '6be899c6-7abe-4461-a0fe-5b7ac91304d6';
const _testName       = 'Suresh Jadhav';
const _testPhone      = '7214512511';
const _testEmail      = 'suresh@example.com';

// ✅ Convert to ConsumerStatefulWidget so we can register callbacks once
class TotalAmountSection extends ConsumerStatefulWidget {
  const TotalAmountSection({super.key});

  @override
  ConsumerState<TotalAmountSection> createState() => _TotalAmountSectionState();
}

class _TotalAmountSectionState extends ConsumerState<TotalAmountSection> {

  @override
  void initState() {
    super.initState();
    // Wire callbacks after first frame so ref/context are ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = ref.read(paymentControllerProvider.notifier);

      // ── On payment success → go to pay success screen ──────────────
      ctrl.onSuccess = (paymentId) {
        if (!mounted) return;
        context.pushNamed(AppRoutesName.paysuccessPagename);
      };

      // ── On failure → show snackbar ─────────────────────────────────
      ctrl.onFailure = (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:         Text(error),
            backgroundColor: Colors.red.shade600,
            behavior:        SnackBarBehavior.floating,
          ),
        );
      };
    });
  }

  void _onNextTapped() {
    ref.read(paymentControllerProvider.notifier).initiatePayment(
      orderId:       _testOrderId,
      customerName:  _testName,
      customerPhone: _testPhone,
      customerEmail: _testEmail,
      razorpayKeyId: _razorpayKeyId,
      description:   'Dash Logistics Delivery',
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentControllerProvider);
    final isLoading    = paymentState.status == PaymentStatus.loading;

    return Column(
      children: [
        SizedBox(height: 6.h),

        // ── Total amount row ──────────────────────────────────────────
        Row(
          children: [
            Image.asset(
              "assets/Images/Banknotes.png",
              height: 28.h,
              width:  28.w,
              errorBuilder: (_, _, _) => Icon(
                Icons.currency_rupee,
                size:  24.sp,
                color: AppColors.lemongreen,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Total Amount",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize:   14.sp,
                color:      AppColors.lemongreen,
              ),
            ),
            const Spacer(),
            Text(
              "₹455",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize:   15.sp,
                color:      Colors.black87,
              ),
            ),
          ],
        ),

        SizedBox(height: 18.h),

        // ── Next button → triggers Razorpay ──────────────────────────
        SizedBox(
          height: 52.h,
          width:  double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:         AppColors.lemongreen,
              disabledBackgroundColor: AppColors.lemongreen.withOpacity(0.6),
              foregroundColor:         Colors.white,
              elevation:               2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            onPressed: isLoading ? null : _onNextTapped,
            child: isLoading
                ? SizedBox(
                    width:  22.w,
                    height: 22.h,
                    child: const CircularProgressIndicator(
                      color:       Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    "Next",
                    style: TextStyle(
                      fontSize:      16.sp,
                      fontWeight:    FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}