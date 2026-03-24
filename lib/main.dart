import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'shell.dart';
import 'providers/theme_provider.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: AtelierApp(),
    ),
  );

  // Ask for permissions only after the UI is spun up.
  Future.delayed(const Duration(seconds: 1), () {
    NotificationService.requestPermissions();
  });
}

class AtelierApp extends ConsumerWidget {
  AtelierApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        ColorScheme? lightScheme;
        ColorScheme? darkScheme;

        if (themeState.useDynamicColor) {
          lightScheme = lightDynamic;
          darkScheme = darkDynamic;
        }

        return MaterialApp(
          title: 'Atelier',
          debugShowCheckedModeBanner: false,
          theme: AtelierTheme.light(lightScheme),
          darkTheme: AtelierTheme.dark(darkScheme),
          themeMode: themeState.themeMode,
          home: _EntryGate(),
        );
      },
    );
  }
}

class _EntryGate extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final seen = prefs.getBool('onboarding_done') ?? false;

    if (!seen) {
      return OnboardingScreen(
        onComplete: () {
          prefs.setBool('onboarding_done', true);
          // Force rebuild
          (context as Element).markNeedsBuild();
        },
      );
    }

    return AppShell();
  }
}
