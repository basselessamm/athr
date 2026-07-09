import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/features/settings/providers/settings_provider.dart';
import 'package:quran_flutter/quran.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final readingMode = ref.watch(readingModeProvider);
    final quranFontSize = ref.watch(quranFontSizeProvider);
    final hadithFontSize = ref.watch(hadithFontSizeProvider);
    final azkarFontSize = ref.watch(azkarFontSizeProvider);
    final reduceMotion = ref.watch(reduceMotionProvider);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return AthrScaffold(
      title: 'الإعدادات',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Theme Settings
            _SettingsCard(
              title: 'المظهر ونمط القراءة',
              subtitle: 'اختر وضعية الألوان للتطبيق',
              icon: Icons.palette_rounded,
              child: Row(
                children: [
                  Expanded(
                    child: _ThemeChoiceTile(
                      title: 'فاتح',
                      icon: Icons.light_mode_rounded,
                      isSelected: readingMode == ReadingMode.light,
                      onTap: () => ref
                          .read(readingModeProvider.notifier)
                          .setMode(ReadingMode.light),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ThemeChoiceTile(
                      title: 'داكن',
                      icon: Icons.dark_mode_rounded,
                      isSelected: readingMode == ReadingMode.dark,
                      onTap: () => ref
                          .read(readingModeProvider.notifier)
                          .setMode(ReadingMode.dark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Accessibility Settings
            _SettingsCard(
              title: 'إمكانية الوصول',
              subtitle: 'تحسين تجربة الاستخدام',
              icon: Icons.accessibility_new_rounded,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: SwitchListTile(
                  title: Text(
                    'تقليل الحركة (Reduce Motion)',
                    style: AppTypography.cairoTextTheme().bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'إيقاف الحركات الانتقالية السريعة',
                    style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: reduceMotion,
                  activeThumbColor: theme.colorScheme.primary,
                  onChanged: (val) {
                    ref.read(reduceMotionProvider.notifier).setMotion(val);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Font Size Settings
            _SettingsCard(
              title: 'أحجام الخطوط',
              subtitle: 'تعديل حجم الخط لكل قسم بشكل مستقل',
              icon: Icons.format_size_rounded,
              child: Column(
                children: [
                  _buildFontSlider(
                    context,
                    'القرآن الكريم',
                    quranFontSize,
                    (val) => ref
                        .read(quranFontSizeProvider.notifier)
                        .setFontSize(val),
                  ),
                  const Divider(),
                  _buildFontSlider(
                    context,
                    'الأحاديث النبوية',
                    hadithFontSize,
                    (val) => ref
                        .read(hadithFontSizeProvider.notifier)
                        .setFontSize(val),
                  ),
                  const Divider(),
                  _buildFontSlider(
                    context,
                    'الأذكار',
                    azkarFontSize,
                    (val) => ref
                        .read(azkarFontSizeProvider.notifier)
                        .setFontSize(val),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Preview text
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'معاينة خط القرآن:',
                          style: AppTypography.cairoTextTheme().labelSmall
                              ?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          Quran.bismillah,
                          style: GoogleFonts.amiri(
                            fontSize: quranFontSize,
                            height: 2.2,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Notifications Settings
            // Notifications Settings
            _SettingsCard(
              title: 'إشعارات الأذكار',
              subtitle: 'تخصيص أوقات الأذكار',
              icon: Icons.notifications_active_rounded,
              child: Column(
                children: [
                  _buildSettingTile(
                    context: context,
                    title: 'أذكار الصباح',
                    subtitle: 'سيتم تذكيرك يومياً',
                    icon: Icons.wb_sunny_rounded,
                    enabled: settings.morningAzkarEnabled,
                    time: settings.morningAzkarTime,
                    onToggle: (val) => settingsNotifier.updateMorningAzkar(val),
                    onTimeChanged: (time) =>
                        settingsNotifier.updateMorningAzkar(settings.morningAzkarEnabled, time),
                  ),
                  const Divider(),
                  _buildSettingTile(
                    context: context,
                    title: 'أذكار المساء',
                    subtitle: 'سيتم تذكيرك يومياً',
                    icon: Icons.nights_stay_rounded,
                    enabled: settings.eveningAzkarEnabled,
                    time: settings.eveningAzkarTime,
                    onToggle: (val) => settingsNotifier.updateEveningAzkar(val),
                    onTimeChanged: (time) =>
                        settingsNotifier.updateEveningAzkar(settings.eveningAzkarEnabled, time),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SettingsCard(
              title: 'إشعارات القرآن والتأمل',
              subtitle: 'تنبيهات ورد القرآن ورسائل أثر',
              icon: Icons.menu_book_rounded,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('تنبيهات ورد القرآن', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('عدة تذكيرات متفرقة خلال اليوم تتوقف فور قراءتك للورد.'),
                    value: settings.quranRemindersEnabled,
                    activeThumbColor: theme.colorScheme.primary,
                    onChanged: (val) => settingsNotifier.updateQuranReminders(val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('رسالة أثر اليومية', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('رسالة إيمانية ملهمة تصلك في منتصف اليوم.'),
                    value: settings.athrMessageEnabled,
                    activeThumbColor: theme.colorScheme.primary,
                    onChanged: (val) => settingsNotifier.updateAthrMessage(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // App Creator Signature
            Column(
              children: [
                Text(
                  'DEVELOPED BY',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 3.0,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'BASSEL ESSAM',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 4.0,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool enabled,
    required TimeOfDay time,
    required Function(bool) onToggle,
    required Function(TimeOfDay) onTimeChanged,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SwitchListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          secondary: Icon(icon, color: theme.colorScheme.primary),
          value: enabled,
          activeThumbColor: theme.colorScheme.primary,
          onChanged: onToggle,
        ),
        if (enabled)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            title: const Text('وقت التذكير'),
            trailing: TextButton.icon(
              icon: const Icon(Icons.access_time_rounded),
              label: Text(time.format(context)),
              onPressed: () async {
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: time,
                );
                if (newTime != null) {
                  onTimeChanged(newTime);
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildFontSlider(
    BuildContext context,
    String title,
    double value,
    ValueChanged<double> onChanged,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              Text(
                'أ',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: Slider(
                  value: value,
                  min: 16.0,
                  max: 48.0,
                  divisions: 16,
                  activeColor: theme.colorScheme.primary,
                  inactiveColor: theme.colorScheme.primary.withValues(
                    alpha: 0.2,
                  ),
                  label: value.toStringAsFixed(0),
                  onChanged: onChanged,
                ),
              ),
              Text(
                'أ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.cairoTextTheme().titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                    Text(
                      subtitle,
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
          child,
        ],
      ),
    );
  }
}

class _ThemeChoiceTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeChoiceTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
              size: 28,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
