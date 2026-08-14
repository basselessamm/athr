import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/features/prayer/application/prayer_times.dart';

class PrayerTimesCard extends ConsumerWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = ref.watch(prayerScheduleProvider);
    return schedule.when(
      loading: () => const _PrayerCardShell(
        child: SizedBox(
          height: 188,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => _PrayerCardShell(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_searching_outlined),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'مواعيد الصلاة لموقعك',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                error.toString().replaceFirst('Bad state: ', ''),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  ref.read(prayerLocationRefreshProvider.notifier).state++;
                  ref.invalidate(prayerScheduleProvider);
                },
                icon: const Icon(Icons.my_location_outlined),
                label: const Text('استخدام موقعي'),
              ),
            ],
          ),
        ),
      ),
      data: (schedule) {
        final day = schedule.today;
        if (day == null) {
          return _PrayerCardShell(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: FilledButton.tonal(
                onPressed: () {
                  ref.read(prayerLocationRefreshProvider.notifier).state++;
                  ref.invalidate(prayerScheduleProvider);
                },
                child: const Text('تحديث مواعيد الصلاة'),
              ),
            ),
          );
        }
        return _PrayerScheduleView(day: day);
      },
    );
  }
}

class _PrayerScheduleView extends StatelessWidget {
  const _PrayerScheduleView({required this.day});

  final PrayerDay day;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream<int>.periodic(const Duration(seconds: 30), (tick) => tick),
      builder: (context, snapshot) {
        final next = day.nextPrayer;
        final current = day.currentPrayer;
        return _PrayerCardShell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.mosque_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'مواقيت الصلاة',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            '${day.hijriDate} هـ · ${day.hijriMonth}',
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'إعدادات الصلاة',
                      onPressed: () => context.push('/settings'),
                      icon: const Icon(Icons.tune_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        next == null
                            ? Icons.nights_stay_outlined
                            : Icons.schedule_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              next == null
                                  ? 'اكتملت مواعيد اليوم'
                                  : 'الصلاة القادمة · ${next.name.arabicLabel}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              next == null
                                  ? 'ستظهر مواعيد الغد تلقائيًا عند التحديث.'
                                  : '${_formatTime(next.at)} · بعد ${_countdown(next.at)}',
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  alignment: WrapAlignment.spaceBetween,
                  children: day.moments
                      .map((moment) {
                        final isNext = moment.name == next?.name;
                        final isCurrent =
                            moment.name == current?.name && next == null;
                        return _PrayerPill(
                          name: moment.name.arabicLabel,
                          time: _formatTime(moment.at),
                          emphasized: isNext,
                          current: isCurrent,
                        );
                      })
                      .toList(growable: false),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: () => context.push('/prayer'),
                    icon: const Icon(Icons.arrow_back, size: 17),
                    label: const Text('عرض كل المواقيت'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _formatTime(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${value.hour >= 12 ? 'م' : 'ص'}';
  }

  static String _countdown(DateTime target) {
    final difference = target.difference(DateTime.now());
    if (difference.isNegative) return 'قريبًا';
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    if (hours > 0) return '$hours س $minutes د';
    return '$minutes دقيقة';
  }
}

class _PrayerPill extends StatelessWidget {
  const _PrayerPill({
    required this.name,
    required this.time,
    required this.emphasized,
    required this.current,
  });

  final String name;
  final String time;
  final bool emphasized;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = emphasized
        ? scheme.primary
        : current
        ? scheme.tertiary
        : scheme.surfaceContainerHighest;
    final foreground = emphasized || current
        ? scheme.onPrimary
        : scheme.onSurfaceVariant;
    return Container(
      constraints: const BoxConstraints(minWidth: 58),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: emphasized
            ? Border.all(color: scheme.primary.withValues(alpha: .5))
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(time, style: TextStyle(fontSize: 11, color: foreground)),
        ],
      ),
    );
  }
}

class _PrayerCardShell extends StatelessWidget {
  const _PrayerCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
