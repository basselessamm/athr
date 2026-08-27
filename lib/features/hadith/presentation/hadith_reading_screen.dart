import 'package:flutter/material.dart';

import 'package:midrar/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:midrar/core/widgets/premium_quran_flip_widget.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/features/hadith/providers/hadith_providers.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';
import 'package:midrar/features/hadith/presentation/widgets/hadith_page_widget.dart';
import 'package:midrar/features/memory_capture/presentation/capture_flow.dart';
import 'package:midrar/core/memory/domain/memory_contracts.dart';

class HadithReadingScreen extends ConsumerStatefulWidget {
  final String bookName;
  final int? focusHadithId;

  const HadithReadingScreen({
    super.key,
    required this.bookName,
    this.focusHadithId,
  });

  @override
  ConsumerState<HadithReadingScreen> createState() =>
      _HadithReadingScreenState();
}

class _HadithReadingScreenState extends ConsumerState<HadithReadingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _focusIndex(List<Hadith> hadiths) {
    final focusId = widget.focusHadithId;
    if (focusId == null) return 0;
    final index = hadiths.indexWhere((hadith) => hadith.id == focusId);
    return index < 0 ? 0 : index;
  }

  String _getArabicBookName(String name) {
    if (name.toLowerCase().contains('bukhari')) return 'صحيح البخاري';
    if (name.toLowerCase().contains('muslim')) return 'صحيح مسلم';
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final hadithsAsync = ref.watch(allHadithsProvider(widget.bookName));
    final fontSize = ref.watch(fontSizeProvider);
    final arabicTitle = _getArabicBookName(widget.bookName);

    return Scaffold(
      backgroundColor: AppColors.mushafBackground,
      appBar: AppBar(
        title: Text(
          arabicTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.mushafBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.mushafPaperAlt),
        titleTextStyle: const TextStyle(
          color: AppColors.mushafPaperAlt,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: hadithsAsync.when(
            data: (hadiths) {
              if (hadiths.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد أحاديث في هذا الكتاب.',
                    style: TextStyle(color: AppColors.mushafPaperAlt),
                  ),
                );
              }

              return PremiumQuranFlipWidget(
                initialIndex: _focusIndex(hadiths),
                itemCount: hadiths.length,
                endPage: Container(
                  color: AppColors.mushafPaper,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 80,
                        color: AppColors.mushafGold,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'نهاية الكتاب',
                        style: TextStyle(
                          fontSize: 32,
                          color: AppColors.mushafInkStrong,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.bookName,
                        style: const TextStyle(
                          fontSize: 22,
                          color: AppColors.mushafInkSoft,
                        ),
                      ),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mushafGold,
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
                          'عودة للكتب',
                          style: TextStyle(fontSize: 18),
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
