// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Runs only once when widget loads
    final timer = useRef<Timer?>(null);

    useEffect(() {
      timer.value = Timer(const Duration(seconds: 7), () {
        if (context.mounted) {
          context.go('/login');
        }
      });

      // cleanup when widget is disposed
      return () {
        timer.value?.cancel();
      };
    }, const []);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 245, 244),
      body: Center(
        child: Image.asset(
          "assets/splash/splash_image.png",
          // width: 303.w,
          // height: 128.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}