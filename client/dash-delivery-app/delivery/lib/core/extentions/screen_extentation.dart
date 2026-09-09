import 'package:flutter/material.dart';

extension ModeExtension on BuildContext {
  Brightness get mode => Theme.of(this).brightness;

  bool get isDark => mode == Brightness.dark;

  bool get isLight => mode == Brightness.light;
}
