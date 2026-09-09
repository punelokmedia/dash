// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/dashboard/change_language/shared/language_provider.dart';
import 'package:dash_logistics/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangeLanguageSheet extends HookConsumerWidget {
  const ChangeLanguageSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final l10n = AppLocalizations.of(context);
    final currentLocale = ref.read(languageProvider);
    final selectedLang = useState(currentLocale.languageCode);

    return Padding(
      // ✅ lifts sheet above keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Close Button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  height: 24.h,
                  width: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 16.sp, color: Colors.black54),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            /// Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.changeLanguage,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),

            SizedBox(height: 16.h),

            /// Language Options
            // ✅ ValueListenableBuilder so cards rebuild on tap
            ValueListenableBuilder<String>(
              valueListenable: selectedLang,
              builder: (_, val, _) => Row(
                children: [
                  Expanded(
                    child: _LanguageCard(
                      title: 'English',
                      subtitle: 'English',
                      icon: 'A',
                      value: 'en',
                      isSelected: val == 'en',
                      onTap: () => selectedLang.value = 'en',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _LanguageCard(
                      title: 'Hindi',
                      subtitle: 'हिंदी',
                      icon: 'अ',
                      value: 'hi',
                      isSelected: val == 'hi',
                      onTap: () => selectedLang.value = 'hi',
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// Save Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SizedBox(
                width: double.infinity,
                height: 58.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lemon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: () {
                    ref.read(languageProvider.notifier).state = Locale(
                      selectedLang.value,
                    );
                    context.pop();
                  },
                  child: Text(
                    'Save Language',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),

            // ✅ safe area bottom gap
            SizedBox(height: MediaQuery.of(context).padding.bottom + 4.h),
          ],
        ),
      ),
    );
  }
}

// ── Language Card — StatelessWidget so Expanded works correctly ───────────────
class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.lemon.withOpacity(0.08)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.lemon : Colors.transparent,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // ✅ don't stretch wider than content
            children: [
              // ✅ FittedBox prevents 54.sp icon overflowing narrow cards
              Flexible(
                flex: 0,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    icon,
                    style: TextStyle(
                      fontSize: 54.sp,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.lemon : AppColors.lightgrey,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 18.w),

              // ✅ Flexible prevents text overflow on small screens
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: isSelected ? AppColors.lemon : AppColors.black37,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isSelected
                            ? AppColors.lemon
                            : AppColors.lightgrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
