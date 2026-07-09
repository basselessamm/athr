import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:athr/core/theme/app_colors.dart';
import 'package:athr/features/progress/providers/monthly_progress_provider.dart';

class QuranMonthlyReportScreen extends ConsumerWidget {
  const QuranMonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final progressAsync = ref.watch(monthlyProgressProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقرير الورد الشهري', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Month Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    ref.read(selectedMonthProvider.notifier).state = 
                        DateTime(selectedMonth.year, selectedMonth.month - 1);
                  },
                ),
                Text(
                  DateFormat('MMMM yyyy', 'ar').format(selectedMonth),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    final now = DateTime.now();
                    final nextMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
                    // Don't go into the future
                    if (nextMonth.isBefore(DateTime(now.year, now.month + 1))) {
                      ref.read(selectedMonthProvider.notifier).state = nextMonth;
                    }
                  },
                ),
              ],
            ),
          ),
          
          Expanded(
            child: progressAsync.when(
              data: (progressMap) => _buildCalendarGrid(context, selectedMonth, progressMap),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('حدث خطأ: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, DateTime selectedMonth, Map<DateTime, bool> progressMap) {
    final theme = Theme.of(context);
    final daysInMonth = DateUtils.getDaysInMonth(selectedMonth.year, selectedMonth.month);
    final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    
    // 1 = Monday, 7 = Sunday. We want to start on Sunday or Saturday for Arabic locales,
    // but DateUtils uses DateTime.weekday (1=Mon..7=Sun). 
    // Let's shift it so Sunday is 0.
    final firstWeekday = firstDayOfMonth.weekday % 7; 

    final weekDays = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

    int totalRead = 0;
    progressMap.forEach((key, value) {
      if (value) totalRead++;
    });

    return Column(
      children: [
        // Summary Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'أيام القراءة',
                  count: totalRead.toString(),
                  color: Colors.green.shade600,
                  icon: Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'أيام فائتة',
                  count: (DateTime.now().month == selectedMonth.month 
                          ? DateTime.now().day - totalRead 
                          : daysInMonth - totalRead).toString(),
                  color: Colors.red.shade400,
                  icon: Icons.cancel_outlined,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Days Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((d) => 
              SizedBox(
                width: 40, 
                child: Center(
                  child: Text(d.substring(0, 3), 
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6)
                    )
                  )
                )
              )
            ).toList(),
          ),
        ),
        const SizedBox(height: 8),

        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: daysInMonth + firstWeekday,
            itemBuilder: (context, index) {
              if (index < firstWeekday) {
                return const SizedBox.shrink();
              }
              final day = index - firstWeekday + 1;
              final date = DateTime(selectedMonth.year, selectedMonth.month, day);
              
              final isToday = DateUtils.isSameDay(date, DateTime.now());
              final isFuture = date.isAfter(DateTime.now());
              
              final readStatus = progressMap[date]; // true if read, false if false, null if no record
              
              Color cellColor = theme.colorScheme.surfaceVariant;
              Color textColor = theme.colorScheme.onSurface;
              
              if (isFuture) {
                cellColor = theme.colorScheme.surfaceVariant.withOpacity(0.3);
                textColor = theme.colorScheme.onSurface.withOpacity(0.3);
              } else if (readStatus == true) {
                cellColor = Colors.green.shade500;
                textColor = Colors.white;
              } else if (readStatus == false || (!isFuture && readStatus == null && !isToday)) {
                cellColor = Colors.red.shade100; // missed day
                if (theme.brightness == Brightness.dark) {
                  cellColor = Colors.red.shade900.withOpacity(0.4);
                }
              }

              return Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  shape: BoxShape.circle,
                  border: isToday ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
                ),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, {required String title, required String count, required Color color, required IconData icon}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(count, style: theme.textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
          Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
