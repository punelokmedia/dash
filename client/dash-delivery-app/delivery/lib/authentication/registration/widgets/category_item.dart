import 'package:delivary_partner/authentication/registration/infra/vehicle_registration.dart';
import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:delivary_partner/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// flutter_gen generates SvgGenImage

// ─────────────────────────────────────────────
// DATA CLASS  — uses SvgGenImage, not String
// ─────────────────────────────────────────────
class CategoryItemData {
  final String label;
  final VehicleCategory cat;
  final SvgGenImage icon; // ← SvgGenImage from flutter_gen

  const CategoryItemData({
    required this.label,
    required this.cat,
    required this.icon,
  });
}

// ─────────────────────────────────────────────
// WIDGET
// ─────────────────────────────────────────────
class CategoryItem extends StatelessWidget {
  final CategoryItemData data;
  final VehicleCategory? selectedCategory;
  final ValueChanged<VehicleCategory> onTap;

  const CategoryItem({
    super.key,
    required this.data,
    required this.selectedCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedCategory == data.cat;

    return GestureDetector(
      onTap: () => onTap(data.cat),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 53.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedBg : AppColors.cardBg,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          // borderRadius: BorderRadius.circular(40.r),
           borderRadius: BorderRadius.circular(50.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.12)
                    : AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Center(
                // flutter_gen's .svg() — tint via colorFilter
                child: data.icon.svg(
                  width: 22.w,
                  height: 22.w,
                  // colorFilter: ColorFilter.mode(
                  //   isSelected ? AppColors.primary : AppColors.textMedium,
                  //   BlendMode.srcIn,
                  // ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                data.label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : Color.fromRGBO(138, 138, 138, 1),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: isSelected ? AppColors.primary : Color.fromRGBO(138, 138, 138, 1),
            ),
          ],
        ),
      ),
    );
  }
}