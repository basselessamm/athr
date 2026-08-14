import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/features/quran/presentation/widgets/book_page_widget.dart';
import 'package:athr/core/widgets/premium_quran_flip_widget.dart';
import 'package:athr/features/quran/presentation/widgets/verse_bottom_sheet.dart';
import 'package:athr/features/quran/application/quran_audio.dart';
import 'package:athr/features/quran/presentation/widgets/quran_audio_player.dart';
import 'package:athr/features/quran/providers/bookmark_provider.dart';
import 'package:athr/features/quran/providers/quran_providers.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeQuran();
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
    unawaited(
      ref
          .read(bookmarkProvider.notifier)
          .saveBookmark(
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
          .read(bookmarkProvider.notifier)
          .saveBookmark(
            surah: widget.surahNumber,
            ayah: ayah,
            pageNumber: pageNumber,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isQuranReady) {
      return Scaffold(
        backgroundColor: const Color(0xFF2C241C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2C241C),
          foregroundColor: const Color(0xFFF9F6EE),
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
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Color(0xFFC7A87D)),
                      SizedBox(height: 16),
                      Text(
                        'يُهيَّأ المصحف للقراءة…',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFF9F6EE)),
                      ),
                    ],
                  )
                : const Text(
                    'تعذرت تهيئة المصحف الآن. حاول مرة أخرى بعد قليل.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFF9F6EE)),
                  ),
          ),
        ),
      );
    }

    final textScale = MediaQuery.textScalerOf(
      context,
    ).scale(1).clamp(0.9, 1.32).toDouble();
    final audioState = ref.watch(quranAudioControllerProvider);
    final highlightedAyah = audioState.surah == widget.surahNumber
        ? audioState.ayah
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF2C241C),
      appBar: AppBar(
        title: Text('سورة ${Quran.getSurahName(widget.surahNumber)}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        backgroundColor: const Color(0xFF2C241C),
        foregroundColor: const Color(0xFFF9F6EE),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFFF9F6EE),
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          IconButton(
            tooltip: 'حفظ موضع القراءة',
            onPressed: _pages.isEmpty
                ? null
                : () {
                    _saveReadingAnchorForPage(_currentPageIndex);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('حُفظ موضع القراءة للعودة إليه لاحقًا.'),
                      ),
                    );
                  },
            icon: const Icon(Icons.bookmark_added_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: PremiumQuranFlipWidget(
          initialIndex: _focusPageIndex,
          itemCount: _pages.length,
          semanticPageLabel: (index, total) =>
              'صفحة ${index + 1} من $total في سورة ${Quran.getSurahName(widget.surahNumber)}',
          onPageChanged: (index) {
            setState(() => _currentPageIndex = index);
            _saveReadingAnchorForPage(index);
          },
          endPage: Container(
            color: const Color(0xFFFDF7EF),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Color(0xFFC7A87D),
                ),
                const SizedBox(height: 24),
                const Text(
                  'نهاية السورة',
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFF5A4328),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'سورة ${Quran.getSurahName(widget.surahNumber)}',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xFF8B6F4E),
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC7A87D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'العودة للقرآن',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          itemBuilder: (context, index) {
            final model = _pages[index];

            return BookPageWidget(
              pageNumber: model.pageNumber,
              headerTitle: 'سورة ${Quran.getSurahName(widget.surahNumber)}',
              headerSubtitle: 'الجزء ${model.juzNum}',
              verses: model.verses,
              textScale: textScale,
              highlightedAyah: highlightedAyah,
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
