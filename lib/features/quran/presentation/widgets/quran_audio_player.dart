import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/features/quran/application/quran_audio.dart';

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
    final duration = state.duration.inMilliseconds == 0
        ? 1
        : state.duration.inMilliseconds;
    final position = state.position.inMilliseconds
        .clamp(0, duration)
        .toDouble();
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
                                  ? 'الآية $currentAyah · ${state.reciter.name}'
                                  : 'استمع إلى السورة',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              state.isLoading
                                  ? 'جارٍ الاتصال بالمصدر الصوتي…'
                                  : 'تلاوة خارجية حسب اختيارك',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.labelMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _selectReciter(
                          context: context,
                          ref: ref,
                          selected: state.reciter,
                        ),
                        icon: const Icon(
                          Icons.person_outline_rounded,
                          size: 18,
                        ),
                        label: const Text('القارئ'),
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
                  if (hasAudio) ...[
                    const SizedBox(height: 6),
                    Semantics(
                      slider: true,
                      label: 'موضع التلاوة',
                      value:
                          '${_format(state.position)} من ${_format(state.duration)}',
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
                    Row(
                      children: [
                        Text(
                          _format(state.position),
                          style: textTheme.labelSmall,
                        ),
                        const Spacer(),
                        Text(
                          _format(state.duration),
                          style: textTheme.labelSmall,
                        ),
                      ],
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
                        onPressed: hasAudio && !state.isLoading
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
                        onPressed: hasAudio && !state.isLoading
                            ? controller.next
                            : null,
                        icon: const Icon(Icons.skip_next_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'بث صوتي من Al Quran Cloud · لا تُحفظ التلاوات داخل التطبيق',
                    textAlign: TextAlign.center,
                    style: textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
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

  Future<void> _selectReciter({
    required BuildContext context,
    required WidgetRef ref,
    required QuranReciter selected,
  }) async {
    final scheme = Theme.of(context).colorScheme;
    final reciter = await showModalBottomSheet<QuranReciter>(
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
              const SizedBox(height: 8),
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
                        8,
                        20,
                        8,
                      ),
                      title: Text(reciter.name),
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

    if (reciter != null) {
      await ref
          .read(quranAudioControllerProvider.notifier)
          .selectReciter(reciter);
    }
  }

  static String _format(Duration value) {
    final minutes = value.inMinutes.toString().padLeft(1, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

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
