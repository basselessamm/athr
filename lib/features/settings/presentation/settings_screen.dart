import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/core/services/notification_service.dart';
import 'package:quran_flutter/quran.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);

    return AthrScaffold(
      title: 'الإعدادات',
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          // Theme Settings
          ListTile(
            title: const Text(
              'المظهر',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('اختر وضعية الألوان للتطبيق'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(newSelection.first);
              },
            ),
          ),
          const Divider(height: 32),

          // Font Size Settings
          ListTile(
            title: const Text(
              'حجم خط القرآن والأذكار',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('عدل حجم الخط لتجربة قراءة أفضل'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('أ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Slider(
                    value: fontSize,
                    min: 16.0,
                    max: 48.0,
                    divisions: 16,
                    label: fontSize.toStringAsFixed(0),
                    onChanged: (value) {
                      ref.read(fontSizeProvider.notifier).setFontSize(value);
                    },
                  ),
                ),
                const Text(
                  'أ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Preview text
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            child: Text(
              Quran.bismillah,
              style: GoogleFonts.amiri(fontSize: fontSize, height: 1.8),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(height: 32),

          // Notifications Settings
          ListTile(
            title: const Text(
              'الإشعارات والتذكير',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('تفعيل تنبيه المحاسبة اليومية (9 مساءً)'),
          ),
          Consumer(
            builder: (context, ref, child) {
              final notificationsEnabled = ref.watch(
                notificationsEnabledProvider,
              );
              return SwitchListTile(
                title: const Text('تنبيه المحاسبة اليومية'),
                value: notificationsEnabled,
                onChanged: (val) async {
                  final notifier = ref.read(
                    notificationsEnabledProvider.notifier,
                  );
                  final service = ref.read(notificationServiceProvider);

                  if (val) {
                    final granted = await service.requestPermission();
                    if (granted) {
                      notifier.setEnabled(true);
                      await service.scheduleDailyMuhasaba(21, 0); // 9:00 PM
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تفعيل التنبيه بنجاح.'),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'عذراً، يجب إعطاء صلاحية الإشعارات أولاً.',
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    notifier.setEnabled(false);
                    await service.cancelDailyMuhasaba();
                  }
                },
              );
            },
          ),
          const SizedBox(height: 32),
          // App Creator Signature
          Column(
            children: [
              const Text(
                'DEVELOPED BY',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 3.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'BASSEL ESSAM',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 4.0,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
