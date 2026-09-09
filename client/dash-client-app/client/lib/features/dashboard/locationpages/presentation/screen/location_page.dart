import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/address_tile.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/location_header.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/map_saved.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/pickup_drop_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class LocationPage extends HookConsumerWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.lemon,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Green header (SafeArea inside) ────────────────
          const LocationHeader(),

          // ── White pickup/drop card on green ──────────────
          GestureDetector(
            onTap: (){
              context.pushNamed(AppRoutesName.contactDetailsPagename);
            },
            child: const PickupDropCard()
          ),

          SizedBox(height: 12.h),

          // ── White body ────────────────────────────────────
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const MapSavedToggle(),
                  SizedBox(height: 6.h),
                  const AddressTile(showSave: false),
                  const AddressTile(showSave: true),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}