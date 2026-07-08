import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/features/home/providers/dashboard_context_provider.dart';

void main() {
  group('DashboardContext Tests', () {
    test('Provider should return valid DashboardContext', () {
      final container = ProviderContainer();

      final context = container.read(dashboardContextProvider);

      expect(context.greeting, isNotNull);
      expect(context.hijriDate, isNotNull);
    });
  });
}
