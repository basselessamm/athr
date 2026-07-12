import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// Maps notification payloads to the correct app route.
///
/// Handles the discrepancy between notification short-codes
/// (e.g. 'morning_azkar') and the actual database category names
/// (e.g. 'أذكار الصباح والمساء') by converting them properly.
class NotificationRouter {
  static final Map<String, String> _payloadToRoute = {
    'morning_azkar': '/azkar/${Uri.encodeComponent('أذكار الصباح والمساء')}',
    'evening_azkar': '/azkar/${Uri.encodeComponent('أذكار الصباح والمساء')}',
    'quran': '/quran',
    'athr': '/',
  };

  static String? resolveRoute(String payload) {
    return _payloadToRoute[payload];
  }

  static void navigate(GoRouter router, String payload) {
    final route = resolveRoute(payload);
    if (route != null) {
      router.go(route);
    } else if (kDebugMode) {
      // ignore: avoid_print
      print('⚠️ Unknown notification payload: $payload');
    }
  }
}
