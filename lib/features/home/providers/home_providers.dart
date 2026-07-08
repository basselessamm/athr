import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/features/library/modules/recent_activity/providers/recent_activity_providers.dart';
import 'package:athr/features/library/modules/recent_activity/domain/repositories/recent_activity_repository.dart';

int _getTodaySeed() {
  final now = DateTime.now();
  return now.year * 10000 + now.month * 100 + now.day;
}

String _dateKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

class DailyVerseData {
  final int surah;
  final int ayah;
  final String surahName;
  final String text;
  final String source;

  const DailyVerseData({
    required this.surah,
    required this.ayah,
    required this.surahName,
    required this.text,
    required this.source,
  });
}

class DailyProgress {
  final bool taskCompleted;
  final bool sunnahCompleted;
  final int streak;

  const DailyProgress({
    required this.taskCompleted,
    required this.sunnahCompleted,
    required this.streak,
  });
}

final dailyVerseProvider = Provider<DailyVerseData>((ref) {
  final random = Random(_getTodaySeed());
  final surah = random.nextInt(Quran.surahCount) + 1;
  final ayahCount = Quran.getTotalVersesInSurah(surah);
  final ayah = random.nextInt(ayahCount) + 1;

  return DailyVerseData(
    surah: surah,
    ayah: ayah,
    surahName: Quran.getSurahName(surah),
    text: Quran.getVerse(surahNumber: surah, verseNumber: ayah).text,
    source: 'القرآن الكريم',
  );
});

Future<T?> _pickByOffset<T>({
  required int seed,
  required Future<int> Function() countLoader,
  required Future<T?> Function(int offset) rowLoader,
}) async {
  final count = await countLoader();
  if (count == 0) {
    return null;
  }

  final offset = Random(seed).nextInt(count);
  return rowLoader(offset);
}

final dailyHadithProvider = FutureProvider<Hadith?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return _pickByOffset<Hadith>(
    seed: _getTodaySeed(),
    countLoader: () async {
      final row = await db
          .customSelect('SELECT COUNT(*) AS count FROM hadith_table')
          .getSingle();
      return row.read<int>('count');
    },
    rowLoader: (offset) {
      return (db.select(
        db.hadithTable,
      )..limit(1, offset: offset)).getSingleOrNull();
    },
  );
});

final dailyDuaProvider = FutureProvider<Dua?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return _pickByOffset<Dua>(
    seed: _getTodaySeed() + 1,
    countLoader: () async {
      final row = await db
          .customSelect('SELECT COUNT(*) AS count FROM dua_table')
          .getSingle();
      return row.read<int>('count');
    },
    rowLoader: (offset) {
      return (db.select(
        db.duaTable,
      )..limit(1, offset: offset)).getSingleOrNull();
    },
  );
});

final dailySunnahProvider = FutureProvider<DailySunnah?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getDailySunnahForSeed(_getTodaySeed() + 2);
});

final dailyTaskProvider = FutureProvider<DailyTask?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getDailyTaskForSeed(_getTodaySeed() + 3);
});

final todayActivityProvider = StreamProvider<UserDailyActivity?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchTodayActivity();
});

final todayMuhasabaProvider = StreamProvider<MuhasabaEntry?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchTodayMuhasaba();
});

final dailyProgressProvider = StreamProvider<DailyProgress>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchAllActivities().map((activities) {
    final todayKey = _dateKey(DateTime.now());
    UserDailyActivity? today;
    for (final activity in activities) {
      if (activity.activityDate == todayKey) {
        today = activity;
        break;
      }
    }

    final activityByDay = {
      for (final activity in activities) activity.activityDate: activity,
    };

    var streak = 0;
    var cursor = DateTime.now();
    while (true) {
      final key = _dateKey(cursor);
      final activity = activityByDay[key];
      if (activity == null) {
        break;
      }

      final hasCompletedSomething =
          (activity.completedTaskId?.isNotEmpty ?? false) ||
          (activity.completedSunnahId?.isNotEmpty ?? false);
      if (!hasCompletedSomething) {
        break;
      }

      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return DailyProgress(
      taskCompleted: today?.completedTaskId?.isNotEmpty ?? false,
      sunnahCompleted: today?.completedSunnahId?.isNotEmpty ?? false,
      streak: streak,
    );
  });
});

final completionActionsProvider = Provider<CompletionActions>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final recentActivities = ref.watch(recentActivityRepositoryProvider);
  return CompletionActions(db, recentActivities);
});

class CompletionActions {
  final AppDatabase _db;
  final RecentActivityRepository _recentActivities;

  const CompletionActions(this._db, this._recentActivities);

  Future<void> toggleTask({required String taskId, required bool isCompleted}) {
    return _db.setDailyTaskCompletion(taskId: taskId, isCompleted: isCompleted);
  }

  Future<void> toggleSunnah({
    required String sunnahId,
    required bool isCompleted,
  }) {
    return _db.setDailySunnahCompletion(
      sunnahId: sunnahId,
      isCompleted: isCompleted,
    );
  }

  Future<void> saveMuhasaba({
    required bool prayed,
    required bool guardedTongue,
    required bool honoredParents,
    required bool avoidedHarm,
    required bool gaveCharity,
    required bool quranRead,
    String? note,
  }) async {
    await _db.saveMuhasabaEntry(
      prayed: prayed,
      guardedTongue: guardedTongue,
      honoredParents: honoredParents,
      avoidedHarm: avoidedHarm,
      gaveCharity: gaveCharity,
      quranRead: quranRead,
      note: note,
    );
    
    await _recentActivities.addRecentActivity(
      type: 'muhasaba',
      title: 'محاسبة اليوم',
      subtitle: 'تم توثيق المحاسبة اليومية بنجاح',
      routePath: '/muhasaba',
    );
  }
}
