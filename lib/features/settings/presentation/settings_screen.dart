import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

import 'package:midrar/core/services/notification_service.dart';
import 'package:midrar/core/widgets/midrar_scaffold.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final prayerSettings = ref.watch(prayerSettingsProvider);
    final prayerSchedule = ref.watch(prayerScheduleProvider);

    return MidrarScaffold(
      title: 'الإعدادات',
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            const _SectionHeader(
              icon: Icons.palette_outlined,
              title: 'المظهر والقراءة',
              subtitle: 'اضبط ما يريح عينك أثناء القراءة.',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('النظام'),
                    icon: Icon(Icons.brightness_auto),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('فاتح'),
                    icon: Icon(Icons.wb_sunny),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('داكن'),
                    icon: Icon(Icons.nightlight_round),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (selection) => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(selection.first),
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              title: const Text(
                'حجم خط القراءة',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'يطبّق على المصحف والأذكار والحديث، مع دعم تكبير خط النظام.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('أ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Slider(
                      value: fontSize,
                      min: 16,
                      max: 48,
                      divisions: 16,
                      label: fontSize.toStringAsFixed(0),
                      onChanged: ref
                          .read(fontSizeProvider.notifier)
                          .setFontSize,
                    ),
                  ),
                  const Text(
                    'أ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                Quran.bismillah,
                style: GoogleFonts.amiri(fontSize: fontSize, height: 1.8),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 38),
            const _SectionHeader(
              icon: Icons.mosque_outlined,
              title: 'مواعيد الصلاة',
              subtitle:
                  'تستخدم الموقع وطريقة الحساب التي تختارها. لا تُعرض أوقات تجريبية.',
            ),
            prayerSchedule.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(20),
                child: LinearProgressIndicator(),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(prayerLocationRefreshProvider.notifier).state++;
                    ref.invalidate(prayerScheduleProvider);
                  },
                  icon: const Icon(Icons.my_location_outlined),
                  label: const Text('السماح بالموقع وتحديث المواقيت'),
                ),
              ),
              data: (schedule) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'تم التحديث لموقعك بدقة تقريبية ${schedule.location.accuracy.toStringAsFixed(0)} م',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          ref
                              .read(prayerLocationRefreshProvider.notifier)
                              .state++;
                          ref.invalidate(prayerScheduleProvider);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('تحديث الموقع والمواقيت'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'طريقة الحساب',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'جهات حوسبة معتمدة؛ اختر ما تعتمده جهتك المحلية. لا تُقدَّم أيّ طريقة كالوحيدة الصحيحة.',
              ),
              trailing: DropdownButton<int>(
                value: prayerSettings.calculationMethod,
                onChanged: (method) async {
                  if (method == null) return;
                  await ref
                      .read(prayerSettingsProvider.notifier)
                      .setMethod(method);
                  ref.invalidate(prayerScheduleProvider);
                  if (prayerSettings.notificationsEnabled) {
                    if (!context.mounted) return;
                    await _reschedulePrayers(context, ref);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: 5,
                    child: Text('الهيئة المصرية للمساحة'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('رابطة العالم الإسلامي'),
                  ),
                  DropdownMenuItem(value: 4, child: Text('أم القرى')),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'مذهب حساب العصر',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'خلاف مشروع بين الفقهاء: الجمهور تظلل واحد، والحنفيان تظليلان. اختر ما يوافق مذهبك.',
              ),
              trailing: DropdownButton<AsrSchool>(
                value: prayerSettings.asrSchool,
                onChanged: (school) async {
                  if (school == null) return;
                  await ref
                      .read(prayerSettingsProvider.notifier)
                      .setAsrHanafi(school == AsrSchool.hanafi);
                  ref.invalidate(prayerScheduleProvider);
                  if (prayerSettings.notificationsEnabled) {
                    if (!context.mounted) return;
                    await _reschedulePrayers(context, ref);
                  }
                },
                items: AsrSchool.values
                    .map(
                      (school) => DropdownMenuItem(
                        value: school,
                        child: Text(school.arabicLabel),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'التقويم الهجري المعروض فلكي حسابي وقد يختلف عن الرؤية الشرعية في بلدك بيوم أو أكثر.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.right,
              ),
            ),
            SwitchListTile.adaptive(
              value: prayerSettings.notificationsEnabled,
              title: const Text(
                'تنبيهات الصلاة',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'تنبيهات محلية للصلوات التي تختارها، دون رسائل التزام أو تذكير عام.',
              ),
              secondary: const Icon(Icons.notifications_active_outlined),
              onChanged: (enabled) =>
                  _setPrayerNotifications(context, ref, enabled),
            ),
            SwitchListTile.adaptive(
              value: prayerSettings.soundEnabled,
              title: const Text(
                'صوت الصلاة المنطوق',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'ينطق اسم الصلاة بصوت محلي قصير عند الموعد، ويعمل دون إنترنت. هذا المفتاح مستقل عن إشعار الصلاة.',
              ),
              secondary: const Icon(Icons.record_voice_over_outlined),
              onChanged: (enabled) async {
                await ref
                    .read(prayerSettingsProvider.notifier)
                    .setSound(enabled);
                if (prayerSettings.notificationsEnabled) {
                  if (!context.mounted) return;
                  await _reschedulePrayers(context, ref);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await ref
                            .read(notificationServiceProvider)
                            .showPrayerAudioTest(PrayerName.fajr);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'شغّلنا اختبار صوت الفجر؛ استمع لعبارة اسم الصلاة.',
                              ),
                            ),
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تعذر اختبار الصوت: $error'),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('اختبار فوري'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await ref
                            .read(notificationServiceProvider)
                            .schedulePrayerAudioTest(PrayerName.fajr);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'جُدول اختبار الخلفية بعد 15 ثانية؛ اترك التطبيق أو اقفل الشاشة للاستماع.',
                              ),
                            ),
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تعذر جدولة اختبار الصوت: $error'),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.schedule_outlined),
                    label: const Text('اختبار في الخلفية'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'الصلوات المنبّهة',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: PrayerName.values
                    .map((prayer) {
                      return FilterChip(
                        label: Text(prayer.arabicLabel),
                        selected: prayerSettings.enabledPrayers.contains(
                          prayer,
                        ),
                        onSelected: (selected) async {
                          await ref
                              .read(prayerSettingsProvider.notifier)
                              .togglePrayer(prayer, selected);
                          if (prayerSettings.notificationsEnabled) {
                            if (!context.mounted) return;
                            await _reschedulePrayers(context, ref);
                          }
                        },
                      );
                    })
                    .toList(growable: false),
              ),
            ),
            const Divider(height: 38),
            const _SectionHeader(
              icon: Icons.route_outlined,
              title: 'تذكيرات خيوط العودة',
              subtitle:
                  'اختر موعد التذكير من تفاصيل أي خيط؛ لا توجد تذكيرات يومية تلقائية.',
            ),
            const SizedBox(height: 28),
            const _Signature(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Future<void> _setPrayerNotifications(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    await ref.read(prayerSettingsProvider.notifier).setNotifications(enabled);
    if (!context.mounted) return;
    if (enabled) {
      await _reschedulePrayers(context, ref);
    } else {
      final schedule = ref.read(prayerScheduleProvider).valueOrNull;
      if (schedule != null) {
        await ref
            .read(notificationServiceProvider)
            .cancelPrayerNotifications(schedule.days);
      }
    }
  }

  Future<void> _reschedulePrayers(BuildContext context, WidgetRef ref) async {
    try {
      final schedule = await ref.read(prayerScheduleProvider.future);
      final settings = ref.read(prayerSettingsProvider);
      await ref
          .read(notificationServiceProvider)
          .schedulePrayerNotifications(schedule: schedule, settings: settings);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث تنبيهات الصلاة المختارة.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تعذر تفعيل التنبيهات: $error')));
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Signature extends StatelessWidget {
  const _Signature();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'DEVELOPED BY',
          style: TextStyle(fontSize: 10, letterSpacing: 3, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          'BASSEL ESSAM',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 4,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
