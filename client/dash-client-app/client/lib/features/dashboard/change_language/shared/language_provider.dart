// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Holds the boot-time saved code — overridden in main.dart
final initialLocaleProvider = Provider<String>((ref) => 'en');

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    // ✅ reads the seeded initial value
    final code = ref.read(initialLocaleProvider);
    return Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', locale.languageCode);
  }
}

final languageProvider =
    NotifierProvider<LanguageNotifier, Locale>(LanguageNotifier.new);