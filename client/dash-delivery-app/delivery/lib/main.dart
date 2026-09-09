import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
import 'package:delivary_partner/core/constant/my_constant.dart';
import 'package:delivary_partner/core/extentions/tablet_extension.dart';
import 'package:delivary_partner/core/infra/break_point.dart';
import 'package:delivary_partner/core/routes/app_router.dart';
import 'package:delivary_partner/core/shared/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load SharedPreferences before runApp so the router has it on first frame
  final prefs = await SharedPreferences.getInstance();

  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRouter = ref.watch(myAppRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return BambooBreakPoint(
      child: Builder(
        builder: (context) {
          final Size designSize = context.isMobile
              ? const Size(402, 874)
              : const Size(800, 1280);

          return ScreenUtilPlusInit(
            designSize: designSize,
            child: Builder(
              builder: (context) {
                return MaterialApp.router(
                  title: AppConstant.appName,
                  debugShowCheckedModeBanner: false,
                  themeMode: themeMode,
                  routerConfig: myRouter,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(1.0)),
                      child: child!,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}