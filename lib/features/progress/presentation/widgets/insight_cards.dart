import 'package:flutter/material.dart';

class InsightCards extends StatelessWidget {
  final Map<String, dynamic> monthlyStats;

  const InsightCards({super.key, required this.monthlyStats});

  @override
  Widget build(BuildContext context) {
    final totalPages = monthlyStats['totalPages'] as int? ?? 0;
    final totalMinutes = monthlyStats['totalMinutes'] as int? ?? 0;
    final activeDays = monthlyStats['activeDays'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إحصائيات الشهر',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _InsightCard(
              icon: Icons.auto_stories,
              title: 'إجمالي الصفحات',
              value: '$totalPages',
            ),
            _InsightCard(
              icon: Icons.schedule,
              title: 'وقت القراءة',
              value: '$totalMinutes د',
            ),
            _InsightCard(
              icon: Icons.event_available,
              title: 'الأيام النشطة',
              value: '$activeDays',
            ),
            _InsightCard(
              icon: Icons.trending_up,
              title: 'معدل الالتزام',
              value: '${((activeDays / 30) * 100).toInt()}%',
            ),
          ],
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InsightCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
