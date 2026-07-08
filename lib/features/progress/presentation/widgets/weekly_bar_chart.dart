import 'package:flutter/material.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class WeeklyBarChart extends StatelessWidget {
  final List<ProgressRecord> records;

  const WeeklyBarChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    // Generate last 7 days including today
    final List<DateTime> last7Days = List.generate(7, (index) {
      return DateTime.now().subtract(Duration(days: 6 - index));
    });

    // Map records to dates
    final Map<String, ProgressRecord> recordsMap = {
      for (var r in records) r.date: r,
    };

    // Extract minutes for the chart
    final List<int> minutesList = last7Days.map((date) {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final record = recordsMap[dateStr];
      return record != null ? record.readingSeconds ~/ 60 : 0;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نشاط الأسبوع',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'دقائق القراءة في آخر 7 أيام',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: _BarChartPainter(
                data: minutesList,
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: last7Days.map((date) {
              return Text(
                DateFormat('E', 'ar').format(date),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<int> data;
  final Color color;
  final Color backgroundColor;

  _BarChartPainter({
    required this.data,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double barWidth = size.width / (data.length * 2);
    final double spacing =
        (size.width - (barWidth * data.length)) / (data.length - 1);

    final int maxData = data.reduce(math.max);
    final double maxValue = maxData > 0
        ? maxData.toDouble()
        : 1.0; // Avoid division by zero

    final Paint bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final Paint fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < data.length; i++) {
      final double x = i * (barWidth + spacing);
      final double barHeight = (data[i] / maxValue) * size.height;

      // Draw background bar
      final RRect bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 0, barWidth, size.height),
        const Radius.circular(4),
      );
      canvas.drawRRect(bgRect, bgPaint);

      // Draw foreground bar
      if (data[i] > 0) {
        final RRect fgRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
          const Radius.circular(4),
        );
        canvas.drawRRect(fgRect, fgPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
