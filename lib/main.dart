import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athr/core/services/notification_service.dart';
import 'package:athr/core/router/app_router.dart';
import 'package:athr/core/theme/app_theme.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/core/memory/memory_providers.dart';
import 'package:athr/core/memory/domain/memory_contracts.dart';
import 'package:athr/features/memory_return/application/memory_return_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  runApp(
    UncontrolledProviderScope(container: container, child: const AthrApp()),
  );

  // The idempotent legacy migration is scheduled after Flutter has presented
  // its first frame. Quran and notification platform initialization are both
  // deferred to the exact user-facing feature that needs them.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(_bootstrapAfterFirstFrame(container));
  });
}

Future<void> _bootstrapAfterFirstFrame(ProviderContainer container) async {
  try {
    // The legacy migration opens Drift/SQLite. Keep the first interactive Home
    // frame independent of that work; the idempotent migration still runs in
    // this session before any scheduled/return background work depends on it.
    await Future<void>.delayed(const Duration(seconds: 10));
    await Future.wait([
      container.read(memoryFoundationMigrationProvider.future),
    ]);
  } catch (error, stackTrace) {
    // Preserve a usable Home even if an optional platform bootstrap is
    // temporarily unavailable. The app's own feature paths report actionable
    // errors where relevant, and no migration completion flag is set on error.
    debugPrint('Athr bootstrap deferred: $error\n$stackTrace');
  }
}

class AthrApp extends ConsumerWidget {
  const AthrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    ref.read(notificationServiceProvider).setDeepLinkHandler((deepLink) {
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
          if (context.mounted) router.go(destination);
        });
      }();
    });

    return MaterialApp.router(
      title: 'Athr',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
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
