import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/features/favorites/providers/favorites_providers.dart';
import 'package:midrar/features/memory_capture/presentation/capture_flow.dart';
import 'package:midrar/features/quran/application/quran_audio.dart';
import 'package:midrar/features/quran/providers/bookmark_provider.dart';
import 'package:midrar/features/quran/providers/quran_providers.dart';

class VerseBottomSheet extends ConsumerWidget {
  const VerseBottomSheet({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
  });

  final int surahNumber;
  final int ayahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tafseerArgs = (surah: surahNumber, ayah: ayahNumber);
    final tafseerAsync = ref.watch(tafseerProvider(tafseerArgs));
    final verseText = Quran.getVerse(
      surahNumber: surahNumber,
      verseNumber: ayahNumber,
    ).text;
    final reference = '$surahNumber:$ayahNumber';
    final favoriteAsync = ref.watch(
      isFavoriteProvider((type: 'verse', reference: reference)),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.48,
        maxChildSize: 0.94,
        expand: false,
        builder: (context, scrollController) {
          return Material(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 18),
                child: Column(
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
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: scheme.primaryContainer,
                            border: Border.all(
                              color: scheme.primary.withValues(alpha: .22),
                            ),
                          ),
                          child: Text(
                            _toArabicNumerals(ayahNumber),
                            style: GoogleFonts.amiri(
                              color: scheme.onPrimaryContainer,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'سورة ${Quran.getSurahName(surahNumber)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'الآية ${_toArabicNumerals(ayahNumber)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'إغلاق',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            ref
                                .read(quranAudioControllerProvider.notifier)
                                .playAyah(
                                  surah: surahNumber,
                                  ayah: ayahNumber,
                                  totalAyahs: Quran.getTotalVersesInSurah(
                                    surahNumber,
                                  ),
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('بدأت التلاوة من هذه الآية.'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('استمع للآية'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final pageNum = Quran.getPageNumber(
                              surahNumber: surahNumber,
                              verseNumber: ayahNumber,
                            );
                            await ref
                                .read(bookmarkProvider.notifier)
                                .saveBookmark(
                                  surah: surahNumber,
                                  ayah: ayahNumber,
                                  pageNumber: pageNum,
                                );
                            await ref
                                .read(lastReadProvider.notifier)
                                .recordProgress(
                                  surah: surahNumber,
                                  ayah: ayahNumber,
                                  pageNumber: pageNum,
                                );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'حُفظ موضع القراءة: سورة ${Quran.getSurahName(surahNumber)} · الآية $ayahNumber',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.bookmark_rounded),
                          label: const Text('حفظ الموضع'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.secondaryContainer.withValues(
                                alpha: .48,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'من المصدر · القرآن الكريم · $reference',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              18,
                              20,
                              18,
                              18,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: scheme.outlineVariant),
                            ),
                            child: Text(
                              verseText,
                              style: GoogleFonts.amiri(
                                fontSize: 27,
                                height: 2.0,
                                color: scheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 2,
                            children: [
                              IconButton(
                                tooltip: 'نسخ الآية',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: verseText),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم نسخ الآية.'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy_outlined),
                              ),
                              IconButton(
                                tooltip: 'حفظ في المفضلة',
                                onPressed: () async {
                                  await ref
                                      .read(appDatabaseProvider)
                                      .toggleFavorite(
                                        contentType: 'verse',
                                        primaryReference: reference,
                                        title:
                                            'سورة ${Quran.getSurahName(surahNumber)} - الآية $ayahNumber',
                                        contentText: verseText,
                                        source: 'القرآن الكريم',
                                      );
                                },
                                icon: favoriteAsync.when(
                                  data: (isFavorite) => Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isFavorite ? scheme.error : null,
                                  ),
                                  loading: () =>
                                      const Icon(Icons.favorite_border_rounded),
                                  error: (_, _) =>
                                      const Icon(Icons.favorite_border_rounded),
                                ),
                              ),
                              IconButton(
                                tooltip: 'تدوين خاطر',
                                onPressed: () {
                                  showCaptureSheet(
                                    context,
                                    source: CaptureSource(
                                      reference: SourceReference.quranVerse(
                                        surahNumber: surahNumber,
                                        ayahNumber: ayahNumber,
                                        sourceLabel: 'القرآن الكريم',
                                      ),
                                      displayText: verseText,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.bookmark_add_outlined),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Text(
                            'التفسير الميسر',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          tafseerAsync.when(
                            data: (tafseer) => SelectableText(
                              tafseer,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.85,
                                color: scheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            loading: () => const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            error: (_, _) => _TafseerError(
                              onRetry: () =>
                                  ref.invalidate(tafseerProvider(tafseerArgs)),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static String _toArabicNumerals(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = number.toString();
    for (var index = 0; index < english.length; index++) {
      result = result.replaceAll(english[index], arabic[index]);
    }
    return result;
  }
}

class _TafseerError extends StatelessWidget {
  const _TafseerError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: .48),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_off_outlined, color: scheme.error),
          const SizedBox(height: 8),
          Text(
            'تعذر تحميل التفسير الآن.',
            style: TextStyle(color: scheme.onErrorContainer),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
