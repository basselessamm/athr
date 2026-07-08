import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:athr/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('toggleFavorite inserts then removes a favorite', () async {
    await database.toggleFavorite(
      contentType: 'verse',
      primaryReference: '2:255',
      title: 'آية الكرسي',
      contentText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ',
      source: 'اختبار',
    );

    final favoritesAfterInsert = await database.watchFavorites().first;
    expect(favoritesAfterInsert, hasLength(1));
    expect(favoritesAfterInsert.first.primaryReference, '2:255');

    await database.toggleFavorite(
      contentType: 'verse',
      primaryReference: '2:255',
      title: 'آية الكرسي',
      contentText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ',
      source: 'اختبار',
    );

    final favoritesAfterDelete = await database.watchFavorites().first;
    expect(favoritesAfterDelete, isEmpty);
  });

  test('daily task and sunnah completion persist in same row', () async {
    await database.setDailyTaskCompletion(taskId: 'task-1', isCompleted: true);
    await database.setDailySunnahCompletion(
      sunnahId: 'sunnah-1',
      isCompleted: true,
    );

    final todayActivity = await database.watchTodayActivity().first;
    expect(todayActivity, isNotNull);
    expect(todayActivity!.completedTaskId, 'task-1');
    expect(todayActivity.completedSunnahId, 'sunnah-1');

    await database.setDailyTaskCompletion(taskId: 'task-1', isCompleted: false);
    final updatedActivity = await database.watchTodayActivity().first;
    expect(updatedActivity, isNotNull);
    expect(updatedActivity!.completedTaskId, isNull);
    expect(updatedActivity.completedSunnahId, 'sunnah-1');
  });

  test('saveMuhasabaEntry persists note and booleans', () async {
    await database.saveMuhasabaEntry(
      prayed: true,
      guardedTongue: true,
      honoredParents: false,
      avoidedHarm: true,
      gaveCharity: false,
      quranRead: true,
      note: 'مراجعة جيدة لليوم',
    );

    final entry = await database.watchTodayMuhasaba().first;
    expect(entry, isNotNull);
    expect(entry!.prayed, isTrue);
    expect(entry.guardedTongue, isTrue);
    expect(entry.honoredParents, isFalse);
    expect(entry.avoidedHarm, isTrue);
    expect(entry.quranRead, isTrue);
    expect(entry.note, 'مراجعة جيدة لليوم');
  });

  test(
    'database-backed daily sunnah and task can be selected by seed',
    () async {
      await database
          .into(database.dailySunnahTable)
          .insert(
            DailySunnahTableCompanion.insert(
              id: 's1',
              title: 'سنة 1',
              description: 'وصف',
              howToApply: 'تطبيق',
              source: 'مصدر',
              sortOrder: 0,
            ),
          );
      await database
          .into(database.dailyTaskTable)
          .insert(
            DailyTaskTableCompanion.insert(
              id: 't1',
              title: 'مهمة 1',
              description: 'وصف',
              impact: 'أثر',
              sortOrder: 0,
            ),
          );

      final sunnah = await database.getDailySunnahForSeed(1234);
      final task = await database.getDailyTaskForSeed(1234);

      expect(sunnah, isNotNull);
      expect(task, isNotNull);
      expect(sunnah!.id, 's1');
      expect(task!.id, 't1');
    },
  );
}
