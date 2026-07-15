import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_flutter/quran.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/core/notifications/notification_providers.dart';
import 'dart:async';

import 'package:athr/features/quran/presentation/widgets/book_page_widget.dart';
import 'package:athr/features/quran/presentation/widgets/verse_bottom_sheet.dart';
import 'package:athr/features/library/modules/recent_activity/providers/recent_activity_providers.dart';
import 'package:athr/features/progress/providers/progress_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/features/reading_session/data/reading_session_repository.dart';
import 'package:athr/core/theme/reading_theme_extension.dart';
import 'package:athr/core/theme/app_typography.dart';

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
  final int? initialPage;
  final int? highlightAyah;

  const QuranReadingScreen({
    super.key,
    required this.surahNumber,
    this.initialPage,
    this.highlightAyah,
  });

  @override
  ConsumerState<QuranReadingScreen> createState() => _QuranReadingScreenState();
}

class _QuranReadingScreenState extends ConsumerState<QuranReadingScreen>
    with WidgetsBindingObserver {
  late List<QuranPageModel> _pages;
  late PageController _pageController;
  Timer? _readingTimer;
  int _secondsRead = 0;
  int _currentPageIndex = 0;
  final Set<int> _readPages = {};

  int? _activeHighlightSurah;
  int? _activeHighlightAyah;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _calculatePages();

    _activeHighlightSurah = widget.surahNumber;
    _activeHighlightAyah = widget.highlightAyah;

    int? targetPage = widget.initialPage;
    if (targetPage == null && widget.highlightAyah != null) {
      targetPage = Quran.getPageNumber(
        surahNumber: widget.surahNumber,
        verseNumber: widget.highlightAyah!,
      );
    }

    if (targetPage != null) {
      final idx = _pages.indexWhere((p) => p.pageNumber == targetPage);
      if (idx != -1) {
        _currentPageIndex = idx;
      }
    }

    _pageController = PageController(initialPage: _currentPageIndex);

    _startTimer();
    if (_pages.isNotEmpty) {
      _readPages.add(_pages[_currentPageIndex].pageNumber);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '💡 تلميح: اضغط على أي آية لعرض تفسيرها',
              style: AppTypography.cairoTextTheme().labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.9),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _readingTimer?.cancel();
      _saveProgress();
    } else if (state == AppLifecycleState.resumed) {
      _startTimer();
    }
  }

  void _startTimer() {
    _readingTimer?.cancel();
    _readingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsRead++;
    });
  }

  void _saveProgress() {
    final lastPageModel = _pages[_currentPageIndex];

    // Save state restoration
    final currentFontSize = ref.read(quranFontSizeProvider);
    final currentTheme = ref.read(readingModeProvider);

    ref
        .read(readingSessionRepositoryProvider)
        .saveSession(
          featureType: 'quran',
          surahId: widget.surahNumber,
          pageNumber: lastPageModel.pageNumber,
          fontSize: currentFontSize,
          themeId: currentTheme.name,
        );

    // Save to recent activities unconditionally
    ref
        .read(recentActivityRepositoryProvider)
        .addRecentActivity(
          type: 'quran',
          title: 'سورة ${Quran.getSurahName(widget.surahNumber)}',
          subtitle: 'الصفحة ${lastPageModel.pageNumber}',
          routePath: '/quran/${widget.surahNumber}',
        );

    if (_secondsRead > 10 || _readPages.isNotEmpty) {
      ref
          .read(progressRepositoryProvider)
          .updateProgress(
            pagesRead: _readPages.length,
            readingSeconds: _secondsRead,
          );
      
      // Cancel today's reminders since the user has read
      ref.read(notificationServiceProvider).markQuranAsReadForToday();

      // Reset after saving to prevent duplicate tracking
      _secondsRead = 0;
      _readPages.clear();
      _readPages.add(lastPageModel.pageNumber);
    }
  }

  @override
  void didUpdateWidget(QuranReadingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.surahNumber != oldWidget.surahNumber ||
        widget.highlightAyah != oldWidget.highlightAyah) {
      setState(() {
        _activeHighlightSurah = widget.surahNumber;
        _activeHighlightAyah = widget.highlightAyah;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _readingTimer?.cancel();
    _saveProgress();
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
    final quranFontSize = ref.watch(quranFontSizeProvider);

    final readingTheme = Theme.of(context).extension<ReadingThemeExtension>();

    return Scaffold(
      backgroundColor: readingTheme?.pageTextureColor,
      appBar: AppBar(
        title: Text('سورة ${Quran.getSurahName(widget.surahNumber)}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        backgroundColor: readingTheme?.pageTextureColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: _pages.length + 1, // +1 for the end page
          onPageChanged: (index) {
            if (index < _pages.length) {
              _currentPageIndex = index;
              _readPages.add(_pages[index].pageNumber);
              _saveProgress();
            }
          },
          itemBuilder: (context, index) {
            if (index == _pages.length) {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'نهاية السورة',
                      style: AppTypography.cairoTextTheme().headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'سورة ${Quran.getSurahName(widget.surahNumber)}',
                      style: AppTypography.cairoTextTheme().titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'العودة للقرآن',
                        style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final model = _pages[index];
            return BookPageWidget(
              pageNumber: model.pageNumber,
              headerTitle: 'سورة ${Quran.getSurahName(widget.surahNumber)}',
              headerSubtitle: 'الجزء ${model.juzNum}',
              verses: model.verses,
              fontSize: quranFontSize,
              highlightSurah: _activeHighlightSurah,
              highlightAyah: _activeHighlightAyah,
              onAyahTapped: (surah, ayah) async {
                await showModalBottomSheet(
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
                      onFavoriteRemoved: () {
                        if (!mounted) return;
                        setState(() {
                          _activeHighlightSurah = null;
                          _activeHighlightAyah = null;
                        });
                      },
                    ),
                  ),
                );

                if (!mounted) return;

                if (_activeHighlightSurah == surah &&
                    _activeHighlightAyah == ayah) {
                  final isFav = await ref
                      .read(appDatabaseProvider)
                      .watchIsFavorite('quran', '$surah:$ayah')
                      .first;
                  if (!isFav && mounted) {
                    setState(() {
                      _activeHighlightSurah = null;
                      _activeHighlightAyah = null;
                    });
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }
}
