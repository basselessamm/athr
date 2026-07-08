import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/features/quran/presentation/widgets/book_page_widget.dart';
import 'package:athr/core/widgets/premium_quran_flip_widget.dart';
import 'package:athr/features/quran/presentation/widgets/verse_bottom_sheet.dart';

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

  const QuranReadingScreen({super.key, required this.surahNumber});

  @override
  ConsumerState<QuranReadingScreen> createState() => _QuranReadingScreenState();
}

class _QuranReadingScreenState extends ConsumerState<QuranReadingScreen> {
  late List<QuranPageModel> _pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _calculatePages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('سورة ${Quran.getSurahName(widget.surahNumber)}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SafeArea(
        child: PremiumQuranFlipWidget(
          initialIndex: 0,
          itemCount: _pages.length,
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
              onAyahTapped: (surah, ayah) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: VerseBottomSheet(
                      surahNumber: surah,
                      ayahNumber: ayah,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
