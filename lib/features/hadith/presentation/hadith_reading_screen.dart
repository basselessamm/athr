import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/core/theme/app_colors.dart';
import 'package:midrar/core/widgets/premium_quran_flip_widget.dart';
import 'package:midrar/features/hadith/presentation/widgets/hadith_page_widget.dart';
import 'package:midrar/features/hadith/providers/hadith_providers.dart';
import 'package:midrar/features/memory_capture/presentation/capture_flow.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';

class HadithReadingScreen extends ConsumerStatefulWidget {
  final String bookName;
  final int? focusHadithId;
  final String? initialChapter;

  const HadithReadingScreen({
    super.key,
    required this.bookName,
    this.focusHadithId,
    this.initialChapter,
  });

  @override
  ConsumerState<HadithReadingScreen> createState() =>
      _HadithReadingScreenState();
}

class _HadithReadingScreenState extends ConsumerState<HadithReadingScreen> {
  String? _selectedChapter;
  int _flipKeyNonce = 0;

  @override
  void initState() {
    super.initState();
    _selectedChapter = widget.initialChapter;
  }

  int _focusIndex(List<Hadith> hadiths) {
    final focusId = widget.focusHadithId;
    if (focusId == null) return 0;
    final index = hadiths.indexWhere((hadith) => hadith.id == focusId);
    return index < 0 ? 0 : index;
  }

  String _getArabicBookName(String name) {
    if (name.toLowerCase().contains('bukhari') || name.contains('البخاري')) {
      return 'صحيح البخاري';
    }
    if (name.toLowerCase().contains('muslim') || name.contains('مسلم')) {
      return 'صحيح مسلم';
    }
    return name;
  }

  void _showChapterPicker(
    BuildContext context,
    List<HadithChapterInfo> chapters,
    String currentChapter,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.mushafBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            expand: false,
            builder: (_, scrollController) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.mushafGold.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'أبواب ${_getArabicBookName(widget.bookName)}',
                          style: GoogleFonts.amiri(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mushafPaperAlt,
                          ),
                        ),
                        Text(
                          '${chapters.length} باب',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.mushafGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.mushafBorder, height: 1),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: chapters.length,
                      itemBuilder: (context, index) {
                        final ch = chapters[index];
                        final isSelected = ch.chapterName == currentChapter;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor:
                              AppColors.mushafGold.withValues(alpha: 0.12),
                          leading: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.mushafGold
                                  : AppColors.mushafBorder.withValues(alpha: 0.4),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.black
                                    : AppColors.mushafPaperAlt,
                              ),
                            ),
                          ),
                          title: Text(
                            ch.chapterName,
                            style: GoogleFonts.amiri(
                              fontSize: 17,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.mushafGold
                                  : AppColors.mushafPaperAlt,
                            ),
                          ),
                          subtitle: Text(
                            '${ch.hadithCount} حديث',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.mushafInkSoft
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(ctx);
                            if (!isSelected) {
                              setState(() {
                                _selectedChapter = ch.chapterName;
                                _flipKeyNonce++;
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(hadithChaptersProvider(widget.bookName));
    final fontSize = ref.watch(fontSizeProvider);
    final arabicTitle = _getArabicBookName(widget.bookName);

    // If focusHadithId is provided and no chapter is explicitly selected, find its chapter
    if (widget.focusHadithId != null && _selectedChapter == null) {
      final focusChapterAsync = ref.watch(
        hadithChapterForHadithIdProvider(widget.focusHadithId!),
      );
      final focusChapter = focusChapterAsync.value;
      if (focusChapter != null && focusChapter.isNotEmpty) {
        _selectedChapter = focusChapter;
      }
    }

    return chaptersAsync.when(
      data: (chapters) {
        if (chapters.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.mushafBackground,
            appBar: AppBar(
              title: Text(arabicTitle),
              backgroundColor: AppColors.mushafBackground,
            ),
            body: const Center(
              child: Text(
                'لا توجد أحاديث مسجلة في هذا الكتاب.',
                style: TextStyle(color: AppColors.mushafPaperAlt),
              ),
            ),
          );
        }

        final currentChapter =
            _selectedChapter ?? chapters.first.chapterName;
        final currentChapterIndex = chapters.indexWhere(
          (c) => c.chapterName == currentChapter,
        );
        final nextChapter = (currentChapterIndex >= 0 &&
                currentChapterIndex < chapters.length - 1)
            ? chapters[currentChapterIndex + 1]
            : null;

        final hadithsAsync = ref.watch(
          chapterHadithsProvider(
            ChapterHadithsQuery(
              bookName: widget.bookName,
              chapterName: currentChapter,
            ),
          ),
        );

        return Scaffold(
          backgroundColor: AppColors.mushafBackground,
          appBar: AppBar(
            title: InkWell(
              onTap: () =>
                  _showChapterPicker(context, chapters, currentChapter),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            arabicTitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.mushafGold,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            currentChapter,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.amiri(
                              color: AppColors.mushafPaperAlt,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.mushafGold,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: AppColors.mushafBackground,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.mushafPaperAlt),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.format_list_bulleted_rounded,
                  color: AppColors.mushafPaperAlt,
                ),
                tooltip: 'فهرس الأبواب',
                onPressed: () =>
                    _showChapterPicker(context, chapters, currentChapter),
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: hadithsAsync.when(
                data: (hadiths) {
                  if (hadiths.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد أحاديث في هذا الباب.',
                        style: TextStyle(color: AppColors.mushafPaperAlt),
                      ),
                    );
                  }

                  return PremiumQuranFlipWidget(
                    key: ValueKey('hadith_flip_${currentChapter}_$_flipKeyNonce'),
                    initialIndex: _focusIndex(hadiths),
                    itemCount: hadiths.length,
                    endPage: Container(
                      color: AppColors.mushafPaper,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            size: 64,
                            color: AppColors.mushafGold,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'نهاية الباب',
                            style: TextStyle(
                              fontSize: 28,
                              color: AppColors.mushafInkStrong,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentChapter,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiri(
                              fontSize: 20,
                              color: AppColors.mushafInkSoft,
                            ),
                          ),
                          const SizedBox(height: 36),
                          if (nextChapter != null) ...[
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedChapter = nextChapter.chapterName;
                                  _flipKeyNonce++;
                                });
                              },
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: Text(
                                'الانتقال إلى: ${nextChapter.chapterName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mushafGold,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          OutlinedButton(
                            onPressed: () => _showChapterPicker(
                              context,
                              chapters,
                              currentChapter,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.mushafInkStrong,
                              side: const BorderSide(
                                color: AppColors.mushafGold,
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'فهرس جميع الأبواب',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final hadith = hadiths[index];
                      return HadithPageWidget(
                        pageNumber: index + 1,
                        headerTitle: widget.bookName,
                        headerSubtitle: hadith.chapterName ?? 'بدون باب',
                        hadithText: hadith.hadithTextAr,
                        reference: hadith.reference ?? '',
                        fontSize: fontSize,
                        onCapturePressed: () {
                          showCaptureSheet(
                            context,
                            source: CaptureSource(
                              reference: SourceReference.hadith(
                                bookId: _canonicalHadithBookId(widget.bookName),
                                hadithId: hadith.id.toString(),
                                sourceLabel: widget.bookName,
                                sourceBook: widget.bookName,
                                sourceCitation:
                                    hadith.reference ?? 'حديث ${hadith.id}',
                              ),
                              displayText: hadith.hadithTextAr,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                error: (err, st) => Center(
                  child: Text(
                    'حدث خطأ: $err',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.mushafBackground,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
      error: (err, st) => Scaffold(
        backgroundColor: AppColors.mushafBackground,
        body: Center(
          child: Text(
            'حدث خطأ في تحميل الأبواب: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

String _canonicalHadithBookId(String bookName) {
  final normalized = bookName.trim().toLowerCase();
  if (normalized.contains('bukhari') || normalized.contains('البخاري')) {
    return 'bukhari';
  }
  if (normalized.contains('muslim') || normalized.contains('مسلم')) {
    return 'muslim';
  }
  return normalized
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}
