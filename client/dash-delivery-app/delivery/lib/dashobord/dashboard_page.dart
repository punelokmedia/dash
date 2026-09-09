import 'package:delivary_partner/dashobord/widget/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashoboardBase extends HookConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const DashoboardBase({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: BottomNavWidget(navigationShell: navigationShell),
    );
  }
}

