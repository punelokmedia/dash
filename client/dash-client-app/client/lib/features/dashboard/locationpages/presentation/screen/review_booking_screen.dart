import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../widgets/location_card.dart';
import '../widgets/service_card.dart';
import '../widgets/gst_card.dart';
import '../widgets/total_amount_section.dart';
import '../widgets/vehicals_card.dart';

class ReviewBookingScreen extends StatelessWidget {
  const ReviewBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lemongreen,
        leading: Icon(
          Icons.arrow_back_ios,
          color: AppColors.white,
          size: 20.sp,
        ),
        title: Text("Review Booking", style: TextStyle(color: AppColors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: const [
            LocationCard(),
            SizedBox(height: 15),
            VehicleCard(),
            SizedBox(height: 15),
            ServiceCard(),
            SizedBox(height: 15),
            GstCard(),
            SizedBox(height: 15),
            TotalAmountSection(),
          ],
        ),
      ),
    );
  }
}
