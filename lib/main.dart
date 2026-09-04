import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midrar/core/services/notification_service.dart';
import 'package:midrar/core/router/app_router.dart';
import 'package:midrar/core/theme/app_theme.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';
import 'package:midrar/features/prayer/application/prayer_alarm_maintenance.dart';
import 'package:midrar/core/memory/memory_providers.dart';
import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/features/memory_return/application/memory_return_service.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('Midrar flutter error: ${details.exception}');
    };
    ErrorWidget.builder = (details) {
      debugPrint('Midrar widget build error: ${details.exception}');
      return const SizedBox.shrink();
    };
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      debugPrint('Midrar uncaught platform error: $error\n$stackTrace');
      return true;
    };

    final prefs = await SharedPreferences.getInstance();

    // Enable runtime font fetching with graceful fallback
    GoogleFonts.config.allowRuntimeFetching = true;

    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );

    // Notification initialization MUST happen before runApp so that a
    // cold start launched by tapping a notification delivers its payload
    // deterministically (launch details are only available right after the
    // plugin is created, and pending taps must not be lost).
    try {
      await container.read(notificationServiceProvider).init();
    } catch (error, stackTrace) {
      debugPrint('Midrar notification init deferred: $error\n$stackTrace');
    }

    runApp(
      UncontrolledProviderScope(container: container, child: const MidrarApp()),
    );

    // Deferred bootstrap: legacy migration and prayer-alarm maintenance run
    // after the first interactive frame so startup stays instant.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_bootstrapAfterFirstFrame(container));
    });
  }, (error, stackTrace) {
    debugPrint('Midrar uncaught zone error: $error\n$stackTrace');
  });
}

Future<void> _bootstrapAfterFirstFrame(ProviderContainer container) async {
  try {
    // The legacy migration opens Drift/SQLite. Keep the first interactive Home
    // frame independent of that work.
    await Future.wait([
      container.read(memoryFoundationMigrationProvider.future),
    ]);
  } catch (error, stackTrace) {
    debugPrint('Midrar migration deferred: $error\n$stackTrace');
  }

  // Keep Athan reliable: extend/repair scheduled prayer notifications from
  // the cached timetable whenever the app starts. Never blocks or crashes
  // startup; failures are logged and retried on next resume.
  await container.read(prayerAlarmMaintenanceProvider.future);
}

class MidrarApp extends ConsumerStatefulWidget {
  const MidrarApp({super.key});

  @override
  ConsumerState<MidrarApp> createState() => _MidrarAppState();
}

class _MidrarAppState extends ConsumerState<MidrarApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(notificationServiceProvider).setDeepLinkHandler(_handleDeepLink);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh stale timetables (midnight rollover, timezone changes while
      // backgrounded) and re-assert scheduled alarms so they never silently
      // expire.
      ref.invalidate(prayerScheduleProvider);
      unawaited(
        ref.read(prayerAlarmMaintenanceProvider.future).catchError((e) {
          debugPrint('Midrar alarm refresh failed: $e');
        }),
      );
    }
  }

  void _handleDeepLink(String deepLink) {
    final router = ref.read(appRouterProvider);
    () async {
      final threadRoute = NotificationService.parseThreadSourceDeepLink(
        deepLink,
      );
      var destination = deepLink;

      if (threadRoute != null) {
        final thread = await ref
            .read(memoryThreadRepositoryProvider)
            .findThread(threadRoute.threadId);
        if (thread != null) {
          await ref
              .read(memoryReturnServiceProvider)
              .recordReturn(thread, kind: ReturnEventKind.resumed);
        }
        destination = threadRoute.sourceRoute;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.mounted) router.go(destination);
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Midrar',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(appRouterProvider),
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
