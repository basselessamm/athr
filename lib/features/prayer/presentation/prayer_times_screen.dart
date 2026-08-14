import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/prayer/application/prayer_times.dart';
import 'package:athr/features/prayer/presentation/prayer_times_card.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key, this.highlightedPrayer});

  final PrayerName? highlightedPrayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AthrScaffold(
      title: 'مواقيت الصلاة',
      actions: [
        IconButton(
          tooltip: 'إعدادات الصلاة',
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.tune_outlined),
        ),
      ],
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 32),
          children: [
            if (highlightedPrayer != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'تنبيه صلاة ${highlightedPrayer!.arabicLabel}',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'مواقيت اليوم',
              textAlign: TextAlign.right,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'تُحسب حسب موقعك وطريقة الحساب التي اخترتها. يمكنك تعديلها من الإعدادات.',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),
            const PrayerTimesCard(),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.tune_outlined),
              label: const Text('إعدادات المواقيت والتنبيهات'),
            ),
          ],
        ),
      ),
    );
  }
}
