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
        padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 12),
        child: Material(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => showFullPlayerSheet(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outlineVariant),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            state.isLoading
                                ? Icons.cloud_sync_outlined
                                : Icons.graphic_eq_rounded,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hasAudio
                                    ? 'الآية $currentAyah · ${state.reciter.displayName}'
                                    : 'استمع إلى السورة',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                key: const ValueKey('audio-subtitle'),
                                state.isLoading
                                    ? 'جارٍ الاتصال بالمصدر الصوتي…'
                                    : hasAudio
                                    ? 'بث مع حفظ محلي لما تسمعه'
                                    : 'تلاوة من مصدر موثوق حسب اختيارك',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.labelMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'القارئ',
                          onPressed: () =>
                              _selectReciter(context: context, ref: ref),
                          icon: const Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          tooltip: 'مشغل كامل',
                          onPressed: () => showFullPlayerSheet(context),
                          icon: const Icon(Icons.keyboard_arrow_up_rounded),
                        ),
                      ],
                    ),
                    if (state.isLoading) ...[
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ],
                    if (state.error != null) ...[
                      const SizedBox(height: 8),
                      _AudioError(
                        message: state.error!,
                        onRetry: hasAudio
                            ? () => controller.playAyah(
                                surah: state.surah!,
                                ayah: state.ayah!,
                                totalAyahs: state.totalAyahs!,
                              )
                            : null,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'الآية السابقة',
                          onPressed:
                              hasAudio && !state.isLoading
                              ? controller.previous
                              : null,
                          icon: const Icon(Icons.skip_previous_rounded),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: state.isLoading
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
                            icon: state.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(
                                    state.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                  ),
                            label: Text(
                              state.isLoading
                                  ? 'جارٍ التحميل'
                                  : state.isPlaying
                                  ? 'إيقاف مؤقت'
                                  : hasAudio
                                  ? 'استئناف التلاوة'
                                  : 'تشغيل التلاوة',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton.filledTonal(
                          tooltip: 'الآية التالية',
                          onPressed:
                              hasAudio && !state.isLoading
                              ? () => controller.next()
                              : null,
                          icon: const Icon(Icons.skip_next_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
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
    final choice = await showModalBottomSheet<Duration>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 14),
              Text('إيقاف التلاوة بعد…', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final minutes in const [10, 20, 30, 60])
                ListTile(
                  title: Text('$minutes دقائق'),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(Duration(minutes: minutes)),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
    if (choice != null) controller.setSleepTimer(choice);
  }

  Future<void> _showCacheManager(BuildContext context, WidgetRef ref) async {
    final size = await QuranAudioCache.totalSizeBytes();
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'التلاوات المحفوظة',
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'تحفظ مدرار تلقائيًا الآيات التي استمعت إليها لتعمل دون إنترنت عند إعادتها. لا يتم تنزيل المصحف كاملًا أبدًا.',
                  style: Theme.of(sheetContext).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Text('الحجم المستخدم: ${_formatBytes(size)}'),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    await QuranAudioCache.clear();
                    ref.invalidate(quranCacheSizeProvider);
                    if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                  },
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('تفريغ التخزين المؤقت'),
                ),
              ],
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
      child: Container(
        constraints: const BoxConstraints(maxHeight: 560),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
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
  );
}

String surahNameFor(int surah) => Quran.getSurahName(surah);

class _AudioError extends StatelessWidget {
  const _AudioError({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 9, 8, 9),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: .62),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: scheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: scheme.onErrorContainer),
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}

String _format(Duration value) {
  final minutes = value.inMinutes.toString().padLeft(1, '0');
  final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
