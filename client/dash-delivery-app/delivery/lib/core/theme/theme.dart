
import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const FlexSchemeColor tradingAppColors = FlexSchemeColor(
  primary: AppColors.appLightPrimary,
  secondary: AppColors.appLightSecondary,
  primaryContainer: AppColors.appLightSecondaryContainer,
  secondaryContainer: Colors.white,
  // error: AppColors.appError,
);

const FlexSchemeColor tradingAppDarkColors = FlexSchemeColor(
  primary: AppColors.appLightPrimary,
  secondary: AppColors.appLightSecondary,
  primaryContainer: Color(0xFF003166),
  secondaryContainer: Color(0xFF0A3315),
  error: Color(0xFFFF3B30),
);
//!MyThemeApp
mixin MyThemeApp {
  static ThemeData myLightTheme =
      FlexThemeData.light(
        colors: tradingAppColors,
        useMaterial3: true,
        scaffoldBackground: AppColors.ScaffoldBackground,
        primaryContainer: Colors.white,
        surface: Colors.white,
        scheme: .amber,
        subThemesData: const FlexSubThemesData(
          cardBackgroundSchemeColor: SchemeColor.surface,
          cardElevation: 1,
          cardRadius: 12,
          interactionEffects: true,
          inputDecoratorBorderType: FlexInputBorderType.underline,
          inputDecoratorUnfocusedBorderIsColored: false,
          switchSchemeColor: SchemeColor.secondary,
          switchThumbFixedSize: true,
          navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
          navigationBarSelectedIconSchemeColor: SchemeColor.primary,
          elevatedButtonRadius: 8.0,
          appBarBackgroundSchemeColor: SchemeColor.surface,
          appBarScrolledUnderElevation: 0,
          switchAdaptiveCupertinoLike: .apple(),
          switchThumbSchemeColor: .secondaryContainer,
        ),
        visualDensity: .standard,
        textTheme: GoogleFonts.interTextTheme(),
      ).copyWith(
        cardColor: AppColors.cardColor,
        iconTheme: IconThemeData(color: AppColors.mediumIconColor),
        dividerColor: AppColors.dividerColor,
      );

  static ThemeData myTradingDarkTheme =
      FlexThemeData.dark(
        colors: tradingAppDarkColors,
        useMaterial3: true,
        scaffoldBackground: Colors.black,
        surface: const Color(0xFF1C1C1E),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        subThemesData: const FlexSubThemesData(
          interactionEffects: true,
          appBarBackgroundSchemeColor: SchemeColor.surface,
          appBarScrolledUnderElevation: 0,
          navigationBarBackgroundSchemeColor: SchemeColor.surface,
          navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
          navigationBarSelectedIconSchemeColor: SchemeColor.primary,
          inputDecoratorIsFilled: true,
          inputDecoratorFillColor: Color(0xFF2C2C2E),
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorRadius: 10.0,
          inputDecoratorUnfocusedBorderIsColored: false,
          elevatedButtonRadius: 8.0,
        ),
        visualDensity: .standard,
        textTheme: GoogleFonts.interTextTheme(),
      ).copyWith(
        cardColor: AppColors.cardDarkColor,
        iconTheme: IconThemeData(color: AppColors.mediumDarkIconColor),
        dividerColor: AppColors.dividerDarkColor,
      );
}
