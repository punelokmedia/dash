import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/dashboard/address/infra/address_controller.dart';
import 'package:dash_logistics/features/dashboard/address/presentation/widgets/animated_scooter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; 

import '../widgets/address_card.dart';
import '../widgets/address_header.dart';

class SavedAddressPage extends HookConsumerWidget {
  const SavedAddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect(() {
      Future.microtask(() => ref.invalidate(addressControllerProvider));
      return null;
    }, const []);
    
    final addressState = ref.watch(addressControllerProvider);


    return Scaffold(
      backgroundColor: AppColors.lemon,
      body: SizedBox(
        
        child: Column(
          children: [
            /// HEADER
            const AddressHeader(),
        
            /// WHITE SECTION
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.white,),
                child: addressState.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.buttonLemon,)),
        
                  error: (error, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Failed to load addresses",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 12.h),
                        ElevatedButton(
                          onPressed: () => ref
                              .read(addressControllerProvider.notifier)
                              .refresh(),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
        
                  data: (addresses) => Column(
                    children: [
                      /// ADDRESS LIST
                      Expanded(
                        child: addresses.isEmpty
                            ? Center(
                                child: Text(
                                  "No saved addresses",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                itemCount: addresses.length,
                                separatorBuilder: (_, _) =>
                                    SizedBox(height: 12.h),
                                itemBuilder: (context, index) =>
                                    AddressCard(address: addresses[index]),
                              ),
                      ),
        
                      /// VEHICLE IMAGE
                      const AnimatedScooter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}