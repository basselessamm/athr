import 'package:flutter/material.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:intl/intl.dart';

class StreakHeatmap extends StatelessWidget {
  final List<ProgressRecord> records;

  const StreakHeatmap({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    // Show the last 7 days for a clear, premium view
    final List<DateTime> last7Days = List.generate(7, (index) {
      return DateTime.now().subtract(Duration(days: 6 - index));
    });

    final Map<String, ProgressRecord> recordsMap = {
      for (var r in records) r.date: r,
    };

    int currentStreak = 0;
    int bestStreak = 0;

    // Calculate current streak from today backwards
    final List<DateTime> allDaysForStreak = List.generate(365, (index) {
      return DateTime.now().subtract(Duration(days: index));
    });

    for (int i = 0; i < allDaysForStreak.length; i++) {
      final dateStr = DateFormat('yyyy-MM-dd').format(allDaysForStreak[i]);
      if (recordsMap.containsKey(dateStr) &&
          (recordsMap[dateStr]!.pagesRead > 0 ||
              recordsMap[dateStr]!.azkarCount > 0)) {
        currentStreak++;
      } else if (i > 0) {
        // allow missing today if they haven't done it yet, but break if yesterday missed
        break;
      }
    }

    // Calculate best streak from all records
    int tempStreak = 0;
    final sortedRecords = records.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    DateTime? prevDate;
    for (var r in sortedRecords) {
      if (r.pagesRead > 0 || r.azkarCount > 0) {
        final rDate = DateFormat('yyyy-MM-dd').parse(r.date);
        if (prevDate == null || rDate.difference(prevDate).inDays == 1) {
          tempStreak++;
        } else if (rDate.difference(prevDate).inDays > 1) {
          tempStreak = 1;
        }
        if (tempStreak > bestStreak) bestStreak = tempStreak;
        prevDate = rDate;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سلسلة الالتزام',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'أفضل سلسلة: $bestStreak أيام',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$currentStreak يوم',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: last7Days.map((date) {
            final dateStr = DateFormat('yyyy-MM-dd').format(date);
            final record = recordsMap[dateStr];
            final bool isActive =
                record != null &&
                (record.pagesRead > 0 || record.azkarCount > 0);
            final bool isToday =
                dateStr == DateFormat('yyyy-MM-dd').format(DateTime.now());

            return _buildDayItem(context, date, isActive, isToday);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDayItem(
    BuildContext context,
    DateTime date,
    bool isActive,
    bool isToday,
  ) {
    final theme = Theme.of(context);
    final dayNames = ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'];
    final String dayName = dayNames[date.weekday % 7];

    return Column(
      children: [
        Text(
          isToday ? 'اليوم' : dayName,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isToday || isActive
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            border: Border.all(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: isActive ? 0 : 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: isActive
              ? Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: theme.colorScheme.onPrimary,
                )
              : null,
        ),
      ],
    );
  }
}
