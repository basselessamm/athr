import 'package:flutter_test/flutter_test.dart';

import 'package:midrar/core/services/notification_service.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';

void main() {
  test('delivers selected thread deep link to the registered handler', () {
    final service = NotificationService();
    String? received;
    service.setDeepLinkHandler((deepLink) => received = deepLink);

    service.handleDeepLinkPayload('/memory/thread-1');

    expect(received, '/memory/thread-1');
  });

  test('holds a notification deep link until the app registers a handler', () {
    final service = NotificationService();
    service.handleDeepLinkPayload('/quran/18?ayah=10');

    String? received;
    service.setDeepLinkHandler((deepLink) => received = deepLink);

    expect(received, '/quran/18?ayah=10');
  });

  test(
    'carries reminder thread context while preserving exact Quran route',
    () {
      final deepLink = NotificationService.threadSourceDeepLink(
        sourceRoute: '/quran/1?ayah=2',
        threadId: 'thread-verse-1-2',
      );

      expect(
        deepLink,
        '/quran/1?ayah=2&memoryThreadId=thread-verse-1-2&returnOrigin=reminder',
      );

      final route = NotificationService.parseThreadSourceDeepLink(deepLink);
      expect(route, isNotNull);
      expect(route!.threadId, 'thread-verse-1-2');
      expect(route.sourceRoute, '/quran/1?ayah=2');
    },
  );

  test('builds a dedicated prayer destination with optional test context', () {
    expect(
      NotificationService.prayerDeepLink(
        PrayerName.fajr,
        extraQuery: const {'audioBackgroundTest': 'true'},
      ),
      '/prayer?prayer=fajr&audioBackgroundTest=true',
    );
  });

  test('does not reinterpret a non-thread notification deep link', () {
    expect(
      NotificationService.parseThreadSourceDeepLink('/quran/18?ayah=10'),
      isNull,
    );
  });
}
