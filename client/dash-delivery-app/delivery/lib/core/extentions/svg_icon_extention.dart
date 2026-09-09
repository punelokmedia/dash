import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension SvgColorFilterExtension on BuildContext {
  SvgPicture svgIcon(
    String assetName, {
    double? height,
    double? width,
    Color? color,
    BoxFit boxFit = BoxFit.contain,
  }) {
    final isLight = Theme.of(this).brightness == Brightness.light;
    return SvgPicture.asset(
      assetName,
      height: height,
      width: width,
      fit: boxFit,
      colorFilter:
          color != null
              ? ColorFilter.mode(color, BlendMode.srcATop)
              : isLight
              ? null
              : const ColorFilter.mode(Colors.white, BlendMode.srcATop),
    );
  }
}
