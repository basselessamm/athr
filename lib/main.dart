import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:athr/core/notifications/notification_providers.dart';
import 'package:athr/core/router/app_router.dart';
import 'package:athr/core/theme/app_theme.dart';
import 'package:athr/features/prayer/providers/prayer_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/features/settings/providers/settings_provider.dart';
import 'package:quran_flutter/quran.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();
  await _initializeLocalTimezone();

  final prefs = await SharedPreferences.getInstance();

  final initialContainer = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  // Setup notification listener before init
  final notificationService = initialContainer.read(notificationServiceProvider);
  notificationService.selectNotificationStream.stream.listen((String? payload) {
    if (payload != null) {
      // Use finalContainer if possible, but in listener it will use the router instance
      _handleNotificationNavigation(initialContainer.read(appRouterProvider), payload);
    }
  });

  await notificationService.init();
  final initialPayload = await notificationService.getInitialPayload();

  // Create a new container with the initial payload override
  final finalContainer = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      initialPayloadProvider.overrideWithValue(initialPayload),
    ],
  );

  // Initialize Quran package
  await Quran.initialize();
  
  // Prime the settings provider and eagerly reschedule notifications
  final settingsNotifier = finalContainer.read(settingsProvider.notifier);
  finalContainer.read(prayerSettingsProvider);
  finalContainer.read(prayerLocationControllerProvider);
  await settingsNotifier.rescheduleAll();

  runApp(
    UncontrolledProviderScope(container: finalContainer, child: const AthrApp()),
  );
}

Future<void> _initializeLocalTimezone() async {
  try {
    final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(timeZoneInfo.identifier);
    tz.setLocalLocation(location);
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('UTC'));
  }
}

void _handleNotificationNavigation(GoRouter router, String payload) {
  switch (payload) {
    case 'morning_azkar':
      router.go('/azkar/morning');
      break;
    case 'evening_azkar':
      router.go('/azkar/evening');
      break;
    case 'quran':
      router.go('/quran');
      break;
    case 'athr':
      router.go('/');
      break;
  }
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
