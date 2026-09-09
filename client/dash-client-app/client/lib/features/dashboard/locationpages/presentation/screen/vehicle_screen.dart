import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/action_buttons.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/address_card.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/proceed_button.dart';
import 'package:dash_logistics/features/dashboard/locationpages/presentation/widgets/vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SelectVehicleScreen extends StatefulWidget {
  const SelectVehicleScreen({super.key});

  @override
  State<SelectVehicleScreen> createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [

          // ── Green header ──────────────────────────────────────────────
          Container(
            color: AppColors.lemon,
            padding: EdgeInsets.only(
              top:    MediaQuery.of(context).padding.top + 8.h,
              left:   16.w,
              right:  16.w,
              bottom: 14.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Back + title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back,
                          color: Colors.white, size: 20.sp),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Select Vehicle',
                      style: TextStyle(
                        fontSize:   18.sp,
                        fontWeight: FontWeight.bold,
                        color:      Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Address card inside green header
                const AddressSection(),

                SizedBox(height: 10.h),

                // Action buttons inside green header
                const ActionButtons(),

                SizedBox(height: 4.h),
              ],
            ),
          ),

          // ── Vehicle list + proceed ────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 14.h),
                    children: [
                      VehicleCard(
                        title: '3 Wheeler',
                        weight: '500kg',
                        time: '14 mins',
                        price: '₹466',
                        image: 'assets/Icons/vehicles/tata_ace.png',
                        isSelected: selectedIndex == 0,
                        onTap: () => setState(() => selectedIndex = 0),
                      ),
                      VehicleCard(
                        title: 'Tata Ace(Any)',
                        weight: '750kg',
                        time: '14 mins',
                        price: '₹555',
                        image: 'assets/Icons/vehicles/tata_ace.png',
                        isSelected: selectedIndex == 1,
                        onTap: () => setState(() => selectedIndex = 1),
                      ),
                      VehicleCard(
                        title: 'Pickup 9ft',
                        weight: '1700kg',
                        time: '14 mins',
                        price: '₹834',
                        image: 'assets/Icons/vehicles/pickup_9ft.png',
                        isSelected: selectedIndex == 2,
                        onTap: () => setState(() => selectedIndex = 2),
                      ),
                      VehicleCard(
                        title: '14ft',
                        weight: '3500kg',
                        time: '13 mins',
                        price: '₹2234',
                        image: 'assets/Icons/vehicles/14ft.png',
                        isSelected: selectedIndex == 3,
                        onTap: () => setState(() => selectedIndex = 3),
                      ),
                    ],
                  ),
                ),

                // Proceed
                const ProceedButton(),
              ],
            ),
          ),

        ],
      ),
    );
  }
}