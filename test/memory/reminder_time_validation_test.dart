import 'package:athr/features/memory_return/presentation/thread_detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 8, 14, 17, 5);

  test('rejects a reminder selected in the past', () {
    expect(
      isFutureReminderSchedule(DateTime(2026, 8, 14, 17), now: now),
      isFalse,
    );
  });

  test('accepts a reminder selected after the current local time', () {
    expect(
      isFutureReminderSchedule(DateTime(2026, 8, 14, 17, 6), now: now),
      isTrue,
    );
  });
}
