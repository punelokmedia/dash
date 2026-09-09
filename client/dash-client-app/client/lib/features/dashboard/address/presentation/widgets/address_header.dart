import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/dashboard/address/infra/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddressHeader extends ConsumerWidget{
  const AddressHeader({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.lemon,
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22.sp),
            ),

            SizedBox(width: 12.w),

            Text(
              "Saved Addresses",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: ()async{
                await context.pushNamed(AppRoutesName.addAddressPageName);
                ref.invalidate(addressControllerProvider);
                },
              child: Text(
                "Add",
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
