import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athr/core/services/notification_service.dart';
import 'package:athr/core/router/app_router.dart';
import 'package:athr/core/theme/app_theme.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:quran_flutter/quran.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  // Initialize notifications
  final notificationService = container.read(notificationServiceProvider);
  await notificationService.init();

  // Initialize Quran package
  await Quran.initialize();

  runApp(
    UncontrolledProviderScope(container: container, child: const AthrApp()),
  );
}

class AthrApp extends ConsumerWidget {
  const AthrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final readingMode = ref.watch(readingModeProvider);

    ThemeMode themeMode;
    ThemeData lightTheme = AppTheme.lightTheme;
    ThemeData darkTheme = AppTheme.darkTheme;

    switch (readingMode) {
      case ReadingMode.light:
        themeMode = ThemeMode.light;
        break;
      case ReadingMode.dark:
        themeMode = ThemeMode.dark;
        break;
    }

    return MaterialApp.router(
      title: 'Athr',
      restorationScopeId: 'athr_app',
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      highContrastTheme: lightTheme, // High contrast fallback
      highContrastDarkTheme: darkTheme, // High contrast fallback
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // Enforce Arabic RTL globally
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
