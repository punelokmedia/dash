// ignore_for_file: unused_import

import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/dashboard/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


class ProfileMenuCard extends StatelessWidget {
  final int rewardsCount;
  final VoidCallback onSavedAddresses;
  final VoidCallback onGst;
  final VoidCallback onRewards;
  final VoidCallback onRefer;
  final VoidCallback onHelp;
  final VoidCallback onLanguage;
  final VoidCallback onTerms;
  final VoidCallback onLogout;

  const ProfileMenuCard({
    super.key,
    required this.rewardsCount,
    required this.onSavedAddresses,
    required this.onGst,
    required this.onRewards,
    required this.onRefer,
    required this.onHelp,
    required this.onLanguage,
    required this.onTerms,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        children: [
          ProfileMenuTile(
            imagePath:"assets/Icons/profile/bookmark.png" ,
            label: 'Saved Addresses',
            onTap: onSavedAddresses,
          ),
          ProfileMenuTile(
            imagePath: "assets/Icons/profile/overview.png",
            label: 'Add GST Details',
            onTap: onGst,
          ),
          ProfileMenuTile(
            imagePath: "assets/Icons/profile/award_star.png",
            label: 'Dash Rewards',
            trailing: '$rewardsCount',
            onTap: onRewards,
          ),
          ProfileMenuTile(
            imagePath: "assets/Icons/profile/featured_seasonal_and_gifts.png",
            label: 'Refer your friends!',
            onTap: onRefer,
          ),
          ProfileMenuTile(
            imagePath:"assets/Icons/profile/question_mark.png",
            label: 'Help & Support',
            onTap: onHelp,
          ),
          ProfileMenuTile(
            imagePath: "assets/Icons/profile/translate_indic.png",
            label: 'Change Language',
            onTap: onLanguage,
          ),
          ProfileMenuTile(
            imagePath: "assets/Icons/profile/contract.png",
            label: 'Terms & Conditions',
            onTap: onTerms,
          ),
          ProfileMenuTile(
            imagePath: "assets/Icons/profile/logout.png",
            label: 'Log Out',
            labelColor: Colors.redAccent,
            // imagePathColor: Colors.redAccent,
            onTap: onLogout,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}