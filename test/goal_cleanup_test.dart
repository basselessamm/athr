import 'package:flutter_test/flutter_test.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/progress/domain/goal_cleanup.dart';

void main() {
  group('findDuplicateGoalsToDelete', () {
    test(
      'returns duplicate goals across all supported types and keeps latest',
      () {
        final goals = [
          UserGoal(
            id: 1,
            goalType: 'minutes',
            metric: 'quran_minutes',
            title: 'دقائق القراءة',
            icon: 'timer',
            targetValue: 20,
            resetPolicy: 'daily',
            metadata: null,
            updatedAt: '2026-07-09T08:00:00.000',
          ),
          UserGoal(
            id: 2,
            goalType: 'minutes',
            metric: 'quran_minutes',
            title: 'دقائق القراءة',
            icon: 'timer',
            targetValue: 30,
            resetPolicy: 'daily',
            metadata: null,
            updatedAt: '2026-07-09T09:00:00.000',
          ),
          UserGoal(
            id: 3,
            goalType: 'pages',
            metric: 'quran_pages',
            title: 'عدد الصفحات',
            icon: 'menu_book',
            targetValue: 8,
            resetPolicy: 'daily',
            metadata: null,
            updatedAt: '2026-07-09T07:00:00.000',
          ),
          UserGoal(
            id: 4,
            goalType: 'pages',
            metric: 'quran_pages',
            title: 'عدد الصفحات',
            icon: 'menu_book',
            targetValue: 10,
            resetPolicy: 'daily',
            metadata: null,
            updatedAt: '2026-07-09T10:00:00.000',
          ),
          UserGoal(
            id: 5,
            goalType: 'azkar',
            metric: 'azkar_count',
            title: 'الأذكار المنجزة',
            icon: 'shield',
            targetValue: 100,
            resetPolicy: 'daily',
            metadata: null,
            updatedAt: '2026-07-09T11:00:00.000',
          ),
        ];

        final duplicates = findDuplicateGoalsToDelete(goals, {
          'minutes',
          'pages',
          'azkar',
        });

        expect(duplicates.map((goal) => goal.id).toList(), [1, 3]);
      },
    );

    test('keeps latest when timestamps match by comparing id', () {
      final goals = [
        UserGoal(
          id: 7,
          goalType: 'minutes',
          metric: 'quran_minutes',
          title: 'دقائق القراءة',
          icon: 'timer',
          targetValue: 15,
          resetPolicy: 'daily',
          metadata: null,
          updatedAt: '2026-07-09T08:00:00.000',
        ),
        UserGoal(
          id: 8,
          goalType: 'minutes',
          metric: 'quran_minutes',
          title: 'دقائق القراءة',
          icon: 'timer',
          targetValue: 25,
          resetPolicy: 'daily',
          metadata: null,
          updatedAt: '2026-07-09T08:00:00.000',
        ),
      ];

      final duplicates = findDuplicateGoalsToDelete(goals, {'minutes'});

      expect(duplicates, hasLength(1));
      expect(duplicates.first.id, 7);
    });
  });
}
