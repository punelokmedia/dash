import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/features/home/domain/models/past_order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomePastOrders extends StatelessWidget {
  final List<PastOrderModel> orders;
  final void Function(PastOrderModel) onOrderAgain;

  const HomePastOrders({
    super.key,
    required this.orders,
    required this.onOrderAgain,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Past order',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(5, 6, 0, 1),
              fontFamily: AppTextStyles.fontFamilyRoboto,
            ),
          ),
          SizedBox(height: 12.h),
          ...orders.map(
            (o) => _OrderTile(order: o, onOrderAgain: () => onOrderAgain(o)),
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final PastOrderModel order;
  final VoidCallback onOrderAgain;
  const _OrderTile({required this.order, required this.onOrderAgain});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Vehicle image ─────────────────────────────────
          SizedBox(
            width: 65.w,
            height: 41.h,
            child: Image.asset(
              order.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.two_wheeler,
                size: 32.r,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // ── Order info ────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  order.serviceType,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    fontFamily: AppTextStyles.fontFamilyRoboto,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  order.date,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey117),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // ── Amount + button ───────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '₹${order.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontFamily: AppTextStyles.fontFamilyRoboto,
                ),
              ),
              SizedBox(height: 5.h),
              GestureDetector(
                onTap: onOrderAgain,
                child: Container(
                  height: 20.h,
                  width: 77.w,
                  alignment: Alignment.center,
                  // padding: EdgeInsets.symmetric(
                  //     horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Order Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppTextStyles.fontFamilyRoboto,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
