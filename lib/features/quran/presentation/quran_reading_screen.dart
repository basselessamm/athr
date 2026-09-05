import 'dart:async';

import 'package:flutter/material.dart';

import 'package:midrar/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

import 'package:midrar/features/quran/presentation/widgets/book_page_widget.dart';
import 'package:midrar/core/widgets/premium_quran_flip_widget.dart';
import 'package:midrar/features/quran/presentation/widgets/verse_bottom_sheet.dart';
import 'package:midrar/features/quran/application/quran_audio.dart';
import 'package:midrar/features/quran/presentation/widgets/quran_audio_player.dart';
import 'package:midrar/features/quran/providers/bookmark_provider.dart';
import 'package:midrar/features/quran/providers/quran_providers.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';

class QuranPageModel {
  final int pageNumber;
  final List<dynamic> verses;
  final int juzNum;

  QuranPageModel({
    required this.pageNumber,
    required this.verses,
    required this.juzNum,
  });
}

class QuranReadingScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final int? focusAyah;

  const QuranReadingScreen({
    super.key,
    required this.surahNumber,
    this.focusAyah,
  });

  @override
  ConsumerState<QuranReadingScreen> createState() => _QuranReadingScreenState();
}

class _QuranReadingScreenState extends ConsumerState<QuranReadingScreen> {
  var _pages = <QuranPageModel>[];
  var _isQuranReady = false;
  Object? _initializationError;
  var _currentPageIndex = 0;

  /// Drives audio follow-along: when recitation advances, the mushaf turns
  /// to the page of the playing ayah.
  final ValueNotifier<int> _audioFollowIndex = ValueNotifier<int>(-1);
  int? _lastFollowedAyah;

  @override
  void initState() {
    super.initState();
    _initializeQuran();
  }

  void _syncAudioFollow(QuranAudioState audio) {
    if (!audio.isPlaying ||
        audio.surah != widget.surahNumber ||
        audio.ayah == null ||
        _pages.isEmpty) {
      return;
    }
    final ayah = audio.ayah!;
    if (ayah == _lastFollowedAyah) return;
    _lastFollowedAyah = ayah;
    final pageIndex = _pages.indexWhere(
      (page) => page.verses.any((verse) => verse.verseNumber == ayah),
    );
    if (pageIndex >= 0 && pageIndex != _audioFollowIndex.value) {
      _audioFollowIndex.value = pageIndex;
    }
  }

  Future<void> _initializeQuran() async {
    try {
      await ref.read(quranInitializationProvider.future);
      if (!mounted) return;
      setState(() {
        _calculatePages();
        _currentPageIndex = _focusPageIndex;
        _isQuranReady = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || widget.focusAyah == null) return;
        _openFocusedAyah(widget.focusAyah!);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _initializationError = error);
    }
  }

  void _calculatePages() {
    final startPage = Quran.getPageNumber(
      surahNumber: widget.surahNumber,
      verseNumber: 1,
    );
    final ayahCount = Quran.getTotalVersesInSurah(widget.surahNumber);
    final endPage = Quran.getPageNumber(
      surahNumber: widget.surahNumber,
      verseNumber: ayahCount,
    );

    _pages = [];
    for (int p = startPage; p <= endPage; p++) {
      final pageVerses = Quran.getSurahVersesInPageAsList(
        p,
      ).where((pv) => pv.surahNumber == widget.surahNumber).toList();

      List<dynamic> verses = [];
      for (var pv in pageVerses) {
        for (int i = pv.startVerseNumber; i <= pv.endVerseNumber; i++) {
          verses.add(
            Quran.getVerse(surahNumber: widget.surahNumber, verseNumber: i),
          );
        }
      }

      final juzNum = verses.isNotEmpty
          ? Quran.getJuzNumber(
              surahNumber: widget.surahNumber,
              verseNumber: verses.first.verseNumber,
            )
          : 1;

      _pages.add(QuranPageModel(pageNumber: p, verses: verses, juzNum: juzNum));
    }
  }

  int get _focusPageIndex {
    final ayah = widget.focusAyah;
    if (ayah == null) return 0;
    final index = _pages.indexWhere(
      (page) => page.verses.any((verse) => verse.verseNumber == ayah),
    );
    return index < 0 ? 0 : index;
  }

  void _openFocusedAyah(int ayah) {
    if (ayah <= 0 || ayah > Quran.getTotalVersesInSurah(widget.surahNumber)) {
      return;
    }
    _saveReadingAnchorForAyah(ayah);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: VerseBottomSheet(
          surahNumber: widget.surahNumber,
          ayahNumber: ayah,
        ),
      ),
    );
  }

  void _saveReadingAnchorForPage(int index) {
    if (index < 0 || index >= _pages.length || _pages[index].verses.isEmpty) {
      return;
    }
    final page = _pages[index];
    final ayah = page.verses.first.verseNumber as int;
    // Automatic progress only — the explicit bookmark is never overwritten
    // by browsing.
    unawaited(
      ref
          .read(lastReadProvider.notifier)
          .recordProgress(
            surah: widget.surahNumber,
            ayah: ayah,
            pageNumber: page.pageNumber,
          ),
    );
  }

  void _saveReadingAnchorForAyah(int ayah) {
    final pageNumber = Quran.getPageNumber(
      surahNumber: widget.surahNumber,
      verseNumber: ayah,
    );
    unawaited(
      ref
          .read(lastReadProvider.notifier)
          .recordProgress(
            surah: widget.surahNumber,
            ayah: ayah,
            pageNumber: pageNumber,
          ),
    );
  }

  void _pinExplicitBookmark() {
    if (_pages.isEmpty) return;
    final page = _pages[_currentPageIndex.clamp(0, _pages.length - 1)];
    final ayah = page.verses.isEmpty ? 1 : page.verses.first.verseNumber as int;
    ref.read(bookmarkProvider.notifier).saveBookmark(
          surah: widget.surahNumber,
          ayah: ayah,
          pageNumber: page.pageNumber,
        );
    ref.read(lastReadProvider.notifier).recordProgress(
          surah: widget.surahNumber,
          ayah: ayah,
          pageNumber: page.pageNumber,
        );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'عُلِّم موضع القراءة: سورة ${Quran.getSurahName(widget.surahNumber)} · صفحة ${page.pageNumber}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (!_isQuranReady) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          foregroundColor: scheme.onSurface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
          title: const Text('القرآن الكريم'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _initializationError == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: scheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'يُهيَّأ المصحف للقراءة…',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.onSurface),
                      ),
                    ],
                  )
                : Text(
                    'تعذرت تهيئة المصحف الآن. حاول مرة أخرى بعد قليل.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: scheme.onSurface),
                  ),
          ),
        ),
      );
    }

    final systemScale = MediaQuery.textScalerOf(
      context,
    ).scale(1).clamp(0.9, 1.32).toDouble();
    // Combine the OS accessibility scale with the user's in-app reading
    // font size so both affect the mushaf predictably.
    final userFontSize = ref.watch(fontSizeProvider);
    final textScale = (systemScale * (userFontSize / 24)).clamp(0.75, 1.9);

    // Follow-along: turn pages as recitation advances (only while playing).
    ref.listen(quranAudioControllerProvider, (_, audio) => _syncAudioFollow(audio));
    final audioState = ref.watch(quranAudioControllerProvider);
    final highlightedAyah = audioState.surah == widget.surahNumber
        ? audioState.ayah
        : null;

    final currentBookmark = ref.watch(bookmarkProvider);
    final currentPageNumber = (_pages.isNotEmpty &&
            _currentPageIndex >= 0 &&
            _currentPageIndex < _pages.length)
        ? _pages[_currentPageIndex].pageNumber
        : null;
    final isCurrentPageBookmarked = currentBookmark != null &&
        currentBookmark.surah == widget.surahNumber &&
        currentBookmark.pageNumber == currentPageNumber;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('سورة ${Quran.getSurahName(widget.surahNumber)}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
        actions: [
          IconButton(
            tooltip: isCurrentPageBookmarked
                ? 'الموضع محفوظ بالعلامة'
                : 'علّمة هذا الموضع للعودة إليه',
            onPressed: _pages.isEmpty ? null : _pinExplicitBookmark,
            icon: Icon(
              isCurrentPageBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isCurrentPageBookmarked
                  ? AppColors.lightGold
                  : scheme.onSurface,
              size: 26,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: PremiumQuranFlipWidget(
          followIndexNotifier: _audioFollowIndex,
          initialIndex: _focusPageIndex,
          itemCount: _pages.length,
          semanticPageLabel: (index, total) =>
              'صفحة ${index + 1} من $total في سورة ${Quran.getSurahName(widget.surahNumber)}',
          onPageChanged: (index) {
            setState(() => _currentPageIndex = index);
            _saveReadingAnchorForPage(index);
          },
          endPage: Container(
            color: AppColors.mushafPaper,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.surahNumber >= 114
                      ? Icons.verified_rounded
                      : Icons.check_circle_outline,
                  size: 72,
                  color: AppColors.mushafGold,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.surahNumber >= 114
                      ? 'ختم القرآن الكريم'
                      : 'نهاية السورة',
                  style: const TextStyle(
                    fontSize: 30,
                    color: AppColors.mushafInkStrong,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.surahNumber >= 114
                      ? 'تقبل الله طاعتكم وصالح أعمالكم'
                      : 'سورة ${Quran.getSurahName(widget.surahNumber)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.mushafInkSoft,
                  ),
                ),
                const SizedBox(height: 36),
                if (widget.surahNumber < 114) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      context.pushReplacementNamed(
                        'quranReading',
                        pathParameters: {
                          'surahNumber': '${widget.surahNumber + 1}',
                        },
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      'الانتقال إلى سورة ${Quran.getSurahName(widget.surahNumber + 1)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mushafGold,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mushafInkStrong,
                    side: const BorderSide(
                      color: AppColors.mushafGold,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'فهرس السور',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          itemBuilder: (context, index) {
            final model = _pages[index];
            final bool isPageBookmarked = currentBookmark != null &&
                currentBookmark.surah == widget.surahNumber &&
                currentBookmark.pageNumber == model.pageNumber;

            return BookPageWidget(
              pageNumber: model.pageNumber,
              headerTitle: 'سورة ${Quran.getSurahName(widget.surahNumber)}',
              headerSubtitle: 'الجزء ${model.juzNum}',
              verses: model.verses,
              textScale: textScale,
              highlightedAyah: highlightedAyah,
              isBookmarked: isPageBookmarked,
              onAyahTapped: (surah, ayah) {
                _openFocusedAyah(ayah);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: QuranAudioPlayerBar(
        surahNumber: widget.surahNumber,
        totalAyahs: Quran.getTotalVersesInSurah(widget.surahNumber),
      ),
    );
  }
}
