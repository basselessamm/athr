import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/features/hadith/providers/hadith_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/features/hadith/presentation/widgets/hadith_page_widget.dart';

class HadithReadingScreen extends ConsumerStatefulWidget {
  final String bookName;

  const HadithReadingScreen({super.key, required this.bookName});

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

  @override
  Widget build(BuildContext context) {
    final hadithsAsync = ref.watch(allHadithsProvider(widget.bookName));
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Dark background outside the book
      appBar: AppBar(
        title: Text(
          widget.bookName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: hadithsAsync.when(
            data: (hadiths) {
              if (hadiths.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد أحاديث في هذا الكتاب.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return PageView.builder(
                controller: _pageController,
                reverse: true, // RTL scrolling
                physics: const BouncingScrollPhysics(),
                itemCount: hadiths.length + 1,
                itemBuilder: (context, index) {
                  if (index == hadiths.length) {
                    return Container(
                      color: const Color(0xFFFDF7EF),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            size: 80,
                            color: Color(0xFFC7A87D),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'نهاية الكتاب',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFF5A4328),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.bookName,
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
                              'عودة للكتب',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final hadith = hadiths[index];
                  return HadithPageWidget(
                    pageNumber: index + 1,
                    headerTitle: widget.bookName,
                    headerSubtitle: hadith.chapterName ?? 'بدون باب',
                    hadithText: hadith.hadithTextAr,
                    reference: hadith.reference ?? '',
                    fontSize: fontSize,
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
