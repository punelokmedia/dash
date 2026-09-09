import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/features/dashboard/address/domain/address_model.dart';
import 'package:dash_logistics/features/dashboard/address/infra/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class AddressCard extends ConsumerWidget {
  final AddressModel address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6.r)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                address.isDefault ? Icons.home : Icons.location_on,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                address.isDefault ? "Home" : "Other",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          Text(
            "${address.name}, ${address.phone}",
            style: TextStyle(fontSize: 14.sp),
          ),

          SizedBox(height: 4.h),

          Text(
            "${address.house}, ${address.address}, ${address.pincode}",
            style: TextStyle(fontSize: 13.sp),
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoutesName.editAddressPageName,
                    extra: address, // passes the full AddressModel
                  );
                  ref.invalidate(addressControllerProvider);
                },
                child: Container(
                  height: 41.h,
                  width: 174.w,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 30.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, size: 16.sp),
                      SizedBox(width: 6.w),
                      Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 30.w),

              Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: GestureDetector(
                  onTap: () {
                    _showConfirmDialog(context, ref);
                    ref.invalidate(addressControllerProvider);
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(addressControllerProvider.notifier)
                  .deleteAddress(address.id);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
