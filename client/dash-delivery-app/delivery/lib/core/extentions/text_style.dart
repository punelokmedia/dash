
import 'package:delivary_partner/core/constant/my_colors.dart';

import 'package:delivary_partner/core/extentions/screen_extentation.dart';
import 'package:flutter/material.dart';


extension QvipleTextStyleExtension on BuildContext {
  //!Done
  TextStyle get headlineExtraLarge =>
      Theme.of(this).textTheme.headlineLarge!.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: isLight ? Colors.black : Colors.white,
      );
  //!Done
  TextStyle get headlineLarge =>
      Theme.of(this).textTheme.headlineLarge!.copyWith(
        fontSize: 17,
        letterSpacing: -0.5,
        fontWeight: FontWeight.w600,
        color: isLight ? Colors.black : Colors.white,
      );
  //!Done
  TextStyle get headlineMediumTwo =>
      Theme.of(this).textTheme.headlineMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: isLight ? Colors.black : Colors.white,
      );
  //!Done
  TextStyle get headlineMediumOne =>
      Theme.of(this).textTheme.headlineMedium!.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,

        color: isLight ? Colors.black : Colors.white,
      );

  //!Done
  TextStyle get headlineSmall =>
      Theme.of(this).textTheme.headlineSmall!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,

        color: isLight
            ? AppColors.mediumTextColor
            : AppColors.mediumDarkTextColor,

        letterSpacing: 0.5,
      );
  TextStyle get headlineMedium =>
      Theme.of(this).textTheme.headlineSmall!.copyWith(
        fontSize:  14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,

        color: isLight ? Colors.black : Colors.white,
      );

  //!Done
  TextStyle get bodyLarge => Theme.of(this).textTheme.bodyLarge!.copyWith(
    fontSize:  14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    color: isLight
        ? AppColors.mediumHintTextColor
        : AppColors.mediumDarkTextColor,
  );
  TextStyle get bodySmall => Theme.of(this).textTheme.headlineSmall!.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,

    color: isLight ? AppColors.mediumTextColor : AppColors.mediumDarkTextColor,
  );
  //!Done
  TextStyle get title => Theme.of(this).textTheme.bodyLarge!.copyWith(
    fontSize:  14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    color: isLight ? AppColors.titleTextColor : AppColors.mediumDarkTextColor,
  );
}
