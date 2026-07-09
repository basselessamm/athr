import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/features/progress/providers/progress_providers.dart';

final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final monthlyProgressProvider = FutureProvider.autoDispose<Map<DateTime, bool>>((ref) async {
  final date = ref.watch(selectedMonthProvider);
  final repo = ref.watch(progressRepositoryProvider);
  
  final records = await repo.getMonthlyProgress(date.year, date.month);
  
  // Map of date -> read Quran or not (true if pagesRead > 0)
  Map<DateTime, bool> readDays = {};
  for (var record in records) {
    // Parse the date (yyyy-MM-dd)
    final parts = record.date.split('-');
    if (parts.length == 3) {
      final recordDate = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      readDays[recordDate] = record.pagesRead > 0;
    }
  }
  return readDays;
});
