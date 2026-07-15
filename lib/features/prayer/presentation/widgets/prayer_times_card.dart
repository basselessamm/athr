import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_glass_card.dart';
import 'package:athr/features/prayer/domain/prayer_formatters.dart';
import 'package:athr/features/prayer/domain/prayer_enums.dart';
import 'package:athr/features/prayer/providers/prayer_providers.dart';
import 'package:athr/features/prayer/widgets/prayer_live_status.dart';
import 'package:athr/features/prayer/widgets/prayer_time_tile.dart';

import 'package:geolocator/geolocator.dart';

class PrayerTimesCard extends ConsumerWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(prayerSettingsProvider);
    final locationAsync = ref.watch(prayerLocationControllerProvider);
    final scheduleAsync = ref.watch(prayerScheduleProvider);
    
    // We get the current time and snapshot to highlight the next prayer in the list
    final now = ref.watch(prayerSecondTickerProvider).valueOrNull ?? DateTime.now();

    return AthrGlassCard(
      blur: 20,
      opacity: 0.08,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: scheduleAsync.when(
        data: (schedule) {
          if (schedule == null) {
            return _PrayerLocationEmptyState(locationAsync: locationAsync);
          }

          final visibleEntries = settings.showSunrise
              ? schedule.entries
              : schedule.entries.where((entry) => entry.isObligatory).toList();
              
          final snapshot = ref.read(prayerRepositoryProvider).resolveStatus(schedule: schedule, now: now);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'مواقيت الصلاة',
                    style: AppTypography.cairoTextTheme().headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (settings.showHijriDate)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.round),
                      ),
                      child: Text(
                        PrayerFormatters.formatHijriDate(schedule.hijriDate),
                        style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  _InfoPill(
                    label: schedule.location.displayLabel,
                    icon: Icons.my_location_rounded,
                  ),
                  _InfoPill(
                    label: schedule.method.label,
                    icon: Icons.calculate_rounded,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              PrayerLiveStatus(
                schedule: schedule,
                timeFormat: settings.timeFormat,
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 95,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: visibleEntries.length,
                  separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final entry = visibleEntries[index];
                    // We consider the "active" tile to be the next prayer
                    final isActive = entry.type == snapshot.nextPrayer;
                    return PrayerTimeTile(
                      entry: entry,
                      timeFormat: settings.timeFormat,
                      isActive: isActive,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (settings.locationMode == PrayerLocationMode.auto) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final isEnabled = await Geolocator.isLocationServiceEnabled();
                          if (!isEnabled) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('الموقع الجغرافي مغلق'),
                                  content: const Text(
                                    'الرجاء تفعيل خدمة الموقع (GPS) لتحديث أوقات الصلاة بشكل دقيق.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('إلغاء'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Geolocator.openLocationSettings();
                                      },
                                      child: const Text('فتح الإعدادات'),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return;
                          }
                          if (context.mounted) {
                            ref.read(prayerLocationControllerProvider.notifier).activateAutoLocation(forceRefresh: true);
                          }
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('تحديث الموقع'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => context.push('/settings'),
                      icon: const Icon(Icons.tune_rounded, size: 18),
                      label: const Text('الإعدادات'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Text(
            'تعذر حساب المواقيت حالياً: $error',
            style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrayerLocationEmptyState extends StatelessWidget {
  final AsyncValue<Object?> locationAsync;

  const _PrayerLocationEmptyState({required this.locationAsync});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorText = locationAsync.hasError ? locationAsync.error.toString() : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مواقيت الصلاة',
          style: AppTypography.cairoTextTheme().headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          errorText ??
              'لا يوجد موقع نشط بعد. فعّل الموقع التلقائي أو أدخل إحداثيات يدوية مع المنطقة الزمنية من الإعدادات.',
          style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
