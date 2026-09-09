// ignore_for_file: depend_on_referenced_packages

import 'package:dash_logistics/features/dashboard/change_language/presentation/widgets/change_langauge_sheet.dart';
import 'package:dash_logistics/features/dashboard/change_language/shared/language_provider.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangeLanguageScreen extends HookConsumerWidget {
  const ChangeLanguageScreen({super.key});

  Future<void> openLanguageSheet(BuildContext context, WidgetRef ref) async {
    final selectedLang = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const ChangeLanguageSheet();
      },
    );

    if (selectedLang != null) {
      ref.read(languageProvider.notifier).state = Locale(selectedLang);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Language")),

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            openLanguageSheet(context,ref);
          },
          child: const Text("Open Language Selector"),
        ),
      ),
    );
  }
}
