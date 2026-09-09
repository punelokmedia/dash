
import 'package:delivary_partner/core/infra/local_storage_services.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/legacy.dart';

final themeModeProvider = StateProvider.autoDispose<ThemeMode>((ref) {
  final myThemeMode = LocalStorageService.themeModeKey == 'light'
      ? ThemeMode.light
      : LocalStorageService.themeModeKey == 'dark'
      ? ThemeMode.dark
      : ThemeMode.system;
  return myThemeMode;
});
