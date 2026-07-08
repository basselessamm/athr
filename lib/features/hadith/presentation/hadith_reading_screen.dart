import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'package:athr/features/hadith/providers/hadith_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/features/hadith/presentation/widgets/hadith_page_widget.dart';
import 'package:athr/features/progress/providers/progress_providers.dart';
import 'package:athr/features/library/modules/recent_activity/providers/recent_activity_providers.dart';

class HadithReadingScreen extends ConsumerStatefulWidget {
  final String bookName;

  const HadithReadingScreen({super.key, required this.bookName});

  @override
  ConsumerState<HadithReadingScreen> createState() =>
      _HadithReadingScreenState();
}

class _HadithReadingScreenState extends ConsumerState<HadithReadingScreen>
    with WidgetsBindingObserver {
  late PageController _pageController;
  Timer? _readingTimer;
  int _secondsRead = 0;
  int _currentPageIndex = 0;
  final Set<int> _readHadiths = {0};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    _startTimer();
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
    if (_secondsRead > 10 || _readHadiths.length > 1) {
      ref
          .read(progressRepositoryProvider)
          .updateProgress(
            hadithCount: _readHadiths.length,
            readingSeconds: _secondsRead,
          );

      ref
          .read(recentActivityRepositoryProvider)
          .addRecentActivity(
            type: 'hadith',
            title: widget.bookName,
            subtitle: 'الحديث رقم ${_currentPageIndex + 1}',
            routePath: '/hadith/${Uri.encodeComponent(widget.bookName)}',
          );

      _secondsRead = 0;
      _readHadiths.clear();
      _readHadiths.add(_currentPageIndex);
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

  @override
  Widget build(BuildContext context) {
    final hadithsAsync = ref.watch(allHadithsProvider(widget.bookName));
    final fontSize = ref.watch(hadithFontSizeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.bookName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: hadithsAsync.when(
          data: (hadiths) {
            if (hadiths.isEmpty) {
              return const Center(child: Text('لا توجد أحاديث في هذا الكتاب.'));
            }

            return PageView.builder(
              controller: _pageController,
              itemCount: hadiths.length + 1,
              onPageChanged: (index) {
                if (index < hadiths.length) {
                  _currentPageIndex = index;
                  _readHadiths.add(index);
                }
              },
              itemBuilder: (context, index) {
                if (index == hadiths.length) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'نهاية الكتاب',
                          style: TextStyle(
                            fontSize: 32,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.bookName,
                          style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 48),
                        ElevatedButton(
                          onPressed: () => context.pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
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
                  hadithId: hadith.id,
                  bookName: hadith.bookName,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => Center(child: Text('حدث خطأ: $err')),
        ),
      ),
    );
  }
}
