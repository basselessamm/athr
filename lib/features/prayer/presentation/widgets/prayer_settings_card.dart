import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/features/prayer/domain/prayer_enums.dart';
import 'package:athr/features/prayer/domain/prayer_location.dart';
import 'package:athr/features/prayer/providers/prayer_providers.dart';

class PrayerSettingsCard extends ConsumerStatefulWidget {
  const PrayerSettingsCard({super.key});

  @override
  ConsumerState<PrayerSettingsCard> createState() => _PrayerSettingsCardState();
}

class _PrayerSettingsCardState extends ConsumerState<PrayerSettingsCard> {
  Future<void> _showManualLocationSheet(BuildContext context) async {
    final settings = ref.read(prayerSettingsProvider);
    final existing = settings.manualLocation;
    final labelController = TextEditingController(text: existing?.label ?? '');
    final latitudeController = TextEditingController(
      text: existing?.latitude.toString() ?? '',
    );
    final longitudeController = TextEditingController(
      text: existing?.longitude.toString() ?? '',
    );
    final timeZoneController = TextEditingController(
      text: existing?.timeZoneId ?? 'Asia/Riyadh',
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final navigator = Navigator.of(context);
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الموقع اليدوي',
                style: AppTypography.cairoTextTheme().titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: 'اسم مختصر للموقع',
                  hintText: 'مثال: مكة أو لندن',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: latitudeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'خط العرض'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: longitudeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'خط الطول'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: timeZoneController,
                decoration: const InputDecoration(
                  labelText: 'المنطقة الزمنية IANA',
                  hintText: 'مثال: Asia/Riyadh',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () async {
                  final localNavigator = navigator;
                  final latitude = double.tryParse(latitudeController.text.trim());
                  final longitude = double.tryParse(longitudeController.text.trim());
                  final timeZoneId = timeZoneController.text.trim();

                  if (latitude == null || latitude < -90 || latitude > 90) {
                    _showMessage(context, 'أدخل خط عرض صحيحاً بين -90 و 90.');
                    return;
                  }

                  if (longitude == null || longitude < -180 || longitude > 180) {
                    _showMessage(context, 'أدخل خط طول صحيحاً بين -180 و 180.');
                    return;
                  }

                  try {
                    tz.getLocation(timeZoneId);
                  } catch (_) {
                    _showMessage(
                      context,
                      'أدخل منطقة زمنية صالحة مثل Asia/Riyadh أو Europe/London.',
                    );
                    return;
                  }

                  await ref
                      .read(prayerLocationControllerProvider.notifier)
                      .activateManualLocation(
                        PrayerLocation(
                          latitude: latitude,
                          longitude: longitude,
                          timeZoneId: timeZoneId,
                          label: labelController.text.trim().isEmpty
                              ? null
                              : labelController.text.trim(),
                        ),
                      );

                  if (localNavigator.canPop()) {
                    localNavigator.pop();
                  }
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('حفظ الموقع اليدوي'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _switchLocationMode(PrayerLocationMode mode) async {
    if (mode == PrayerLocationMode.auto) {
      await ref
          .read(prayerLocationControllerProvider.notifier)
          .activateAutoLocation();
      return;
    }

    ref.read(prayerSettingsProvider.notifier).setLocationMode(mode);
  }

  Future<void> _openSystemLocationSettings() async {
    await Geolocator.openAppSettings();
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(prayerSettingsProvider);
    final locationAsync = ref.watch(prayerLocationControllerProvider);
    final activeLocation = locationAsync.valueOrNull;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: AppShadows.minimal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.schedule_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مواقيت الصلاة',
                      style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'اضبط طريقة الحساب، المذهب، ونمط الموقع والتنسيق.',
                      style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<PrayerCalculationMethod>(
            initialValue: settings.calculationMethod,
            decoration: const InputDecoration(labelText: 'طريقة الحساب'),
            items: PrayerCalculationMethod.values
                .map(
                  (method) => DropdownMenuItem(
                    value: method,
                    child: Text(method.label),
                  ),
                )
                .toList(growable: false),
            onChanged: (method) {
              if (method != null) {
                ref.read(prayerSettingsProvider.notifier).setCalculationMethod(method);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _SegmentedSetting<PrayerMadhab>(
            title: 'المذهب في العصر',
            value: settings.madhab,
            segments: PrayerMadhab.values
                .map(
                  (madhab) => ButtonSegment<PrayerMadhab>(
                    value: madhab,
                    label: Text(madhab.label),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              ref.read(prayerSettingsProvider.notifier).setMadhab(value);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _SegmentedSetting<PrayerTimeFormat>(
            title: 'تنسيق الوقت',
            value: settings.timeFormat,
            segments: PrayerTimeFormat.values
                .map(
                  (format) => ButtonSegment<PrayerTimeFormat>(
                    value: format,
                    label: Text(format.label),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              ref.read(prayerSettingsProvider.notifier).setTimeFormat(value);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _SegmentedSetting<PrayerLocationMode>(
            title: 'الموقع',
            value: settings.locationMode,
            segments: PrayerLocationMode.values
                .map(
                  (mode) => ButtonSegment<PrayerLocationMode>(
                    value: mode,
                    label: Text(mode.label),
                  ),
                )
                .toList(growable: false),
            onChanged: _switchLocationMode,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الموقع النشط',
                  style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  activeLocation == null
                      ? 'لم يتم حفظ موقع نشط بعد.'
                      : '${activeLocation.displayLabel} - ${activeLocation.timeZoneId}',
                  style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                if (locationAsync.isLoading) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const LinearProgressIndicator(),
                ],
                if (locationAsync.hasError) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    locationAsync.error.toString(),
                    style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    if (settings.locationMode == PrayerLocationMode.auto)
                      FilledButton.tonalIcon(
                        onPressed: () {
                          ref
                              .read(prayerLocationControllerProvider.notifier)
                              .activateAutoLocation(forceRefresh: true);
                        },
                        icon: const Icon(Icons.my_location_rounded),
                        label: const Text('تحديث الموقع الحالي'),
                      ),
                    if (settings.locationMode == PrayerLocationMode.manual)
                      FilledButton.tonalIcon(
                        onPressed: () => _showManualLocationSheet(context),
                        icon: const Icon(Icons.edit_location_alt_rounded),
                        label: const Text('تعديل الموقع اليدوي'),
                      ),
                    if (settings.locationMode == PrayerLocationMode.manual &&
                        settings.manualLocation == null)
                      OutlinedButton.icon(
                        onPressed: () => _showManualLocationSheet(context),
                        icon: const Icon(Icons.add_location_alt_rounded),
                        label: const Text('إضافة موقع يدوي'),
                      ),
                    if (locationAsync.hasError)
                      OutlinedButton.icon(
                        onPressed: _openSystemLocationSettings,
                        icon: const Icon(Icons.settings_outlined),
                        label: const Text('إعدادات الجهاز'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('إظهار الشروق'),
            subtitle: const Text('إضافة الشروق ضمن الجدول اليومي.'),
            value: settings.showSunrise,
            onChanged: (value) {
              ref.read(prayerSettingsProvider.notifier).setShowSunrise(value);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('إظهار التاريخ الهجري'),
            subtitle: const Text('عرض التاريخ الهجري داخل بطاقة المواقيت.'),
            value: settings.showHijriDate,
            onChanged: (value) {
              ref.read(prayerSettingsProvider.notifier).setShowHijriDate(value);
            },
          ),
        ],
      ),
    );
  }
}

class _SegmentedSetting<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<ButtonSegment<T>> segments;
  final ValueChanged<T> onChanged;

  const _SegmentedSetting({
    required this.title,
    required this.value,
    required this.segments,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<T>(
          showSelectedIcon: false,
          segments: segments,
          selected: {value},
          onSelectionChanged: (selection) => onChanged(selection.first),
        ),
      ],
    );
  }
}
