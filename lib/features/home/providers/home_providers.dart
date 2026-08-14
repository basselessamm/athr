import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';

int _getTodaySeed() {
  final now = DateTime.now();
  return now.year * 10000 + now.month * 100 + now.day;
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

final completionActionsProvider = Provider<CompletionActions>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CompletionActions(db);
});

class CompletionActions {
  final AppDatabase _db;

  const CompletionActions(this._db);

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
  }) {
    return _db.saveMuhasabaEntry(
      prayed: prayed,
      guardedTongue: guardedTongue,
      honoredParents: honoredParents,
      avoidedHarm: avoidedHarm,
      gaveCharity: gaveCharity,
      quranRead: quranRead,
      note: note,
    );
  }
}
