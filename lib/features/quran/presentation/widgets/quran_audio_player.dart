import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:midrar/core/theme/app_colors.dart';
import 'package:midrar/features/quran/application/quran_audio.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

/// Compact always-visible bar inside the mushaf screen. Expands into the
/// full player sheet for repeat/speed/sleep/reciter controls.
class QuranAudioPlayerBar extends ConsumerWidget {
  const QuranAudioPlayerBar({
    super.key,
    required this.surahNumber,
    required this.totalAyahs,
  });

  final int surahNumber;
  final int totalAyahs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quranAudioControllerProvider);
    final controller = ref.read(quranAudioControllerProvider.notifier);
    final isThisSurah = state.surah == surahNumber;
    final currentAyah = isThisSurah ? state.ayah : null;
    final hasAudio = currentAyah != null;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 6),
        child: Material(
          color: scheme.surfaceContainerLow,
          elevation: 4,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 10, 8),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Play / Pause circular action button
                      InkWell(
                        onTap: state.isLoading
                            ? null
                            : () {
                                if (!hasAudio) {
                                  controller.playAyah(
                                    surah: surahNumber,
                                    ayah: 1,
                                    totalAyahs: totalAyahs,
                                  );
                                } else {
                                  controller.toggle();
                                }
                              },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 42,
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  state.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: scheme.onPrimary,
                                  size: 26,
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Reciter & Ayah Info - tap to open full player sheet
                      Expanded(
                        child: InkWell(
                          onTap: () => showFullPlayerSheet(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  hasAudio
                                      ? 'الآية $currentAyah · ${state.reciter.displayName}'
                                      : 'استمع إلى سورة ${surahNameFor(surahNumber)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  key: const ValueKey('audio-subtitle'),
                                  state.isLoading
                                      ? 'جارٍ الاتصال بمصدر التلاوة…'
                                      : state.isPlaying
                                          ? 'جاري التلاوة الآن · انقر للمزيد'
                                          : hasAudio
                                              ? 'تلاوة متوقفة · انقر للاستئناف'
                                              : 'تلاوة صوتية مع المتابعة التلقائية',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Controls: Prev / Next
                      if (hasAudio) ...[
                        IconButton(
                          tooltip: 'الآية السابقة',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          onPressed: !state.isLoading ? controller.previous : null,
                          icon: const Icon(Icons.skip_previous_rounded, size: 22),
                        ),
                        IconButton(
                          tooltip: 'الآية التالية',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          onPressed: !state.isLoading ? () => controller.next() : null,
                          icon: const Icon(Icons.skip_next_rounded, size: 22),
                        ),
                      ],
                      // Reciter Picker button
                      IconButton(
                        tooltip: 'تغيير القارئ',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () => _selectReciter(context: context, ref: ref),
                        icon: const Icon(Icons.person_outline_rounded, size: 20),
                      ),
                      // Expand / Full sheet button
                      IconButton(
                        tooltip: 'خيارات التلاوة والمشغل',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () => showFullPlayerSheet(context),
                        icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 24),
                      ),
                    ],
                  ),
                  // Compact Error Alert if any
                  if (state.error != null) ...[
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: hasAudio
                          ? () => controller.playAyah(
                                surah: state.surah!,
                                ayah: state.ayah!,
                                totalAyahs: state.totalAyahs!,
                              )
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: scheme.errorContainer.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.wifi_off_rounded, size: 16, color: scheme.error),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.error!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.labelSmall?.copyWith(color: scheme.onErrorContainer),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'إعادة المحاولة',
                              style: textTheme.labelSmall?.copyWith(
                                color: scheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectReciter({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final selected = ref.read(quranAudioControllerProvider).reciter;
    final reciter = await showReciterPicker(context, selected);
    if (reciter != null) {
      await ref
          .read(quranAudioControllerProvider.notifier)
          .selectReciter(reciter);
    }
  }
}

// ---------------------------------------------------------------------------
// Full player sheet
// ---------------------------------------------------------------------------

Future<void> showFullPlayerSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => const _FullPlayerSheet(),
  );
}

class _FullPlayerSheet extends ConsumerStatefulWidget {
  const _FullPlayerSheet();

  @override
  ConsumerState<_FullPlayerSheet> createState() => _FullPlayerSheetState();
}

class _FullPlayerSheetState extends ConsumerState<_FullPlayerSheet> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quranAudioControllerProvider);
    final controller = ref.read(quranAudioControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final duration = state.duration.inMilliseconds == 0
        ? 1
        : state.duration.inMilliseconds;
    final position = state.position.inMilliseconds.clamp(0, duration).toDouble();
    final surahName = state.surah == null
        ? ''
        : 'سورة ${surahNameFor(state.surah!)}';

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppColors.radiusXl),
            ),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                state.hasSelection
                    ? 'الآية ${state.ayah}'
                    : 'لم تبدأ الاستماع بعد',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                state.hasSelection
                    ? '$surahName · ${state.reciter.displayName}'
                    : 'اختر آية من المصحف أو اضغط تشغيل لبدء السورة',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              Semantics(
                slider: true,
                label: 'موضع التلاوة',
                value:
                    '${_format(state.position)} من ${_format(state.duration)}',
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),
                  child: Slider(
                    value: position,
                    min: 0,
                    max: duration.toDouble(),
                    onChanged: state.isLoading
                        ? null
                        : (value) => controller.seek(
                            Duration(milliseconds: value.round()),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(_format(state.position), style: textTheme.labelSmall),
                    const Spacer(),
                    Text(
                      state.duration == Duration.zero
                          ? '--:--'
                          : '-${_format(state.remaining)}',
                      style: textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Transport row: surah | ayah | play | ayah | surah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: 'السورة السابقة',
                    onPressed: state.hasSelection && !state.isLoading
                        ? controller.previousSurah
                        : null,
                    icon: const Icon(Icons.skip_previous_outlined, size: 28),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'الآية السابقة',
                    onPressed: state.hasSelection && !state.isLoading
                        ? controller.previous
                        : null,
                    icon: const Icon(Icons.skip_previous_rounded, size: 30),
                  ),
                  SizedBox(
                    width: 76,
                    height: 76,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: state.isLoading
                          ? null
                          : () {
                              if (!state.hasSelection) return;
                              controller.toggle();
                            },
                      child: state.isLoading
                          ? const SizedBox(
                              height: 26,
                              width: 26,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              state.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 40,
                            ),
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'الآية التالية',
                    onPressed: state.hasSelection && !state.isLoading
                        ? () => controller.next()
                        : null,
                    icon: const Icon(Icons.skip_next_rounded, size: 30),
                  ),
                  IconButton(
                    tooltip: 'السورة التالية',
                    onPressed: state.hasSelection && !state.isLoading
                        ? controller.nextSurah
                        : null,
                    icon: const Icon(Icons.skip_next_outlined, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Feature row: repeat, speed, sleep
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _PlayerToolButton(
                    icon: switch (state.repeatMode) {
                      QuranRepeatMode.off => Icons.repeat_rounded,
                      QuranRepeatMode.ayah => Icons.repeat_one_rounded,
                      QuranRepeatMode.surah => Icons.repeat_rounded,
                    },
                    label: switch (state.repeatMode) {
                      QuranRepeatMode.off => 'التكرار',
                      QuranRepeatMode.ayah => 'تكرار الآية',
                      QuranRepeatMode.surah => 'تكرار السورة',
                    },
                    active: state.repeatMode != QuranRepeatMode.off,
                    onTap: controller.cycleRepeatMode,
                  ),
                  _PlayerToolButton(
                    icon: Icons.speed_rounded,
                    label: '${state.speed.toStringAsFixed(2)}×',
                    active: state.speed != 1.0,
                    onTap: () {
                      const speeds = [1.0, 0.75, 1.25, 1.5];
                      final current = state.speed;
                      final nextSpeed = speeds.firstWhere(
                        (s) => s > current + 0.01,
                        orElse: () => speeds.first,
                      );
                      controller.setSpeed(nextSpeed);
                    },
                  ),
                  _PlayerToolButton(
                    icon: Icons.bedtime_rounded,
                    label: state.sleepUntil == null
                        ? 'مؤقت النوم'
                        : 'ينتهي ${TimeOfDay.fromDateTime(state.sleepUntil!).format(context)}',
                    active: state.sleepUntil != null,
                    onTap: () => _pickSleepTimer(context, controller, state),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final reciter = await showReciterPicker(
                          context,
                          state.reciter,
                        );
                        if (reciter != null) {
                          await controller.selectReciter(reciter);
                        }
                      },
                      icon: const Icon(Icons.person_outline_rounded, size: 20),
                      label: Text(
                        state.reciter.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.outlined(
                    tooltip: 'التخزين المؤقت للتلاوات',
                    onPressed: () => _showCacheManager(context, ref),
                    icon: const Icon(Icons.storage_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'بث مباشر من مصدر موثوق · تُحفظ محليًا التلاوات التي تسمعها فقط',
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickSleepTimer(
    BuildContext context,
    QuranAudioController controller,
    QuranAudioState state,
  ) async {
    if (state.sleepUntil != null) {
      controller.setSleepTimer(null);
      return;
    }
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final choice = await showModalBottomSheet<Duration>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Material(
          color: scheme.surface,
          elevation: 12,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: scheme.outlineVariant,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'إيقاف التلاوة بعد…',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final minutes in const [10, 20, 30, 60])
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      leading: const Icon(Icons.timer_outlined),
                      title: Text('$minutes دقيقة'),
                      onTap: () =>
                          Navigator.of(sheetContext).pop(Duration(minutes: minutes)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (choice != null) controller.setSleepTimer(choice);
  }

  Future<void> _showCacheManager(BuildContext context, WidgetRef ref) async {
    final size = await QuranAudioCache.totalSizeBytes();
    if (!context.mounted) return;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Material(
          color: scheme.surface,
          elevation: 12,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppColors.radiusXl),
          ),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: scheme.outlineVariant,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheme.primaryContainer.withValues(alpha: 0.5),
                        ),
                        child: Icon(
                          Icons.storage_rounded,
                          color: scheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التلاوات المحفوظة',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'الحجم المستخدم: ${_formatBytes(size)}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHigh.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: scheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                          color: scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'تحفظ مدرار تلقائيًا الآيات التي استمعت إليها لتعمل دون إنترنت عند إعادتها. ولا يتم تنزيل المصحف كاملًا أبدًا لترشيد استهلاك باقة الإنترنت.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.tonalIcon(
                    onPressed: size == 0
                        ? null
                        : () async {
                            await QuranAudioCache.clear();
                            ref.invalidate(quranCacheSizeProvider);
                            if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                          },
                    icon: const Icon(Icons.delete_sweep_outlined),
                    label: const Text('تفريغ التخزين المؤقت'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes ب';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} ك.ب';
    return '${(kb / 1024).toStringAsFixed(1)} م.ب';
  }
}

class _PlayerToolButton extends StatelessWidget {
  const _PlayerToolButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: active ? scheme.primary : scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: active ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reciter picker (shared)
// ---------------------------------------------------------------------------

Future<QuranReciter?> showReciterPicker(
  BuildContext context,
  QuranReciter selected,
) {
  final scheme = Theme.of(context).colorScheme;
  return showModalBottomSheet<QuranReciter>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'اختر القارئ',
              style: Theme.of(
                sheetContext,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Text(
                'جميع التلاوات متحقق منها وتُبث من مصدر موثوق',
                style: Theme.of(sheetContext).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: quranReciters.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, color: scheme.outlineVariant),
                itemBuilder: (context, index) {
                  final reciter = quranReciters[index];
                  final isSelected = reciter.id == selected.id;
                  return ListTile(
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(
                      24,
                      6,
                      20,
                      6,
                    ),
                    title: Text(
                      reciter.displayName,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w800 : null,
                      ),
                    ),
                    subtitle: Text('${reciter.cdnBitrate} kbps'),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: scheme.primary,
                          )
                        : const Icon(Icons.play_circle_outline_rounded),
                    onTap: () => Navigator.of(context).pop(reciter),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  ),
);
}

String surahNameFor(int surah) => Quran.getSurahName(surah);

String _format(Duration value) {
  final minutes = value.inMinutes.toString().padLeft(1, '0');
  final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
