import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/library/modules/recent_activity/providers/recent_activity_providers.dart';
import 'package:athr/features/azkar/providers/azkar_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/features/progress/providers/progress_providers.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/features/favorites/providers/favorites_providers.dart';

class AzkarReadingScreen extends ConsumerStatefulWidget {
  final String category;

  const AzkarReadingScreen({super.key, required this.category});

  @override
  ConsumerState<AzkarReadingScreen> createState() => _AzkarReadingScreenState();
}

class _AzkarReadingScreenState extends ConsumerState<AzkarReadingScreen>
    with WidgetsBindingObserver {
  late PageController _pageController;
  Timer? _readingTimer;
  int _secondsRead = 0;
  int _currentPageIndex = 0;
  final Set<int> _readAzkar = {0};

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
    // Save to recent activities unconditionally
    ref
        .read(recentActivityRepositoryProvider)
        .addRecentActivity(
          type: 'azkar',
          title: widget.category,
          subtitle: 'الذكر رقم ${_currentPageIndex + 1}',
          routePath: '/azkar/${Uri.encodeComponent(widget.category)}',
        );

    if (_secondsRead > 10 || _readAzkar.length > 1) {
      ref
          .read(progressRepositoryProvider)
          .updateProgress(
            azkarCount: _readAzkar.length,
            readingSeconds: _secondsRead,
          );

      _secondsRead = 0;
      _readAzkar.clear();
      _readAzkar.add(_currentPageIndex);
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
    final azkarAsync = ref.watch(azkarByCategoryProvider(widget.category));
    final fontSize = ref.watch(azkarFontSizeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: azkarAsync.when(
          data: (azkar) {
            if (azkar.isEmpty) {
              return const Center(child: Text('لا توجد أذكار في هذا التصنيف.'));
            }

            return PageView.builder(
              controller: _pageController,
              itemCount: azkar.length + 1,
              onPageChanged: (index) {
                if (index < azkar.length) {
                  _currentPageIndex = index;
                  _readAzkar.add(index);
                }
              },
              itemBuilder: (context, index) {
                if (index == azkar.length) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'تم بحمد الله',
                          style: TextStyle(
                            fontSize: 32,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.category,
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
                            'عودة للأذكار',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final zikr = azkar[index];
                return _PremiumZikrPage(
                  key: ValueKey(zikr.id),
                  zikr: zikr,
                  pageNumber: index + 1,
                  totalCount: azkar.length,
                  category: widget.category,
                  fontSize: fontSize,
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

class _PremiumZikrPage extends ConsumerStatefulWidget {
  final Dua zikr;
  final int pageNumber;
  final int totalCount;
  final String category;
  final double fontSize;

  const _PremiumZikrPage({
    super.key,
    required this.zikr,
    required this.pageNumber,
    required this.totalCount,
    required this.category,
    required this.fontSize,
  });

  @override
  ConsumerState<_PremiumZikrPage> createState() => _PremiumZikrPageState();
}

class _PremiumZikrPageState extends ConsumerState<_PremiumZikrPage>
    with AutomaticKeepAliveClientMixin {
  late int _remainingCount;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _remainingCount = _extractRepetitions(widget.zikr.duaText);
  }

  int _extractRepetitions(String text) {
    if (text.contains('ثلاث مرات') || text.contains('3 مرات')) return 3;
    if (text.contains('مائة مرة') || text.contains('100 مرة')) return 100;
    if (text.contains('أربع مرات') || text.contains('4 مرات')) return 4;
    if (text.contains('سبع مرات') || text.contains('7 مرات')) return 7;
    if (text.contains('عشر مرات') || text.contains('10 مرات')) return 10;
    return 1; // Default
  }

  void _handleTap() {
    if (_remainingCount > 0) {
      setState(() {
        _remainingCount--;
      });
      if (_remainingCount > 0) {
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin
    final bool isRightPage = widget.pageNumber % 2 != 0;
    final isDone = _remainingCount == 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: const Color(0xFFFDF7EF), // Base paper color
        child: InkWell(
          onTap: _handleTap,
          splashColor: const Color(0xFFC7A87D).withValues(alpha: 0.2),
          highlightColor: Colors.transparent,
          child: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: isRightPage
                      ? [
                          Colors.black.withValues(alpha: 0.08),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.02),
                        ]
                      : [
                          Colors.black.withValues(alpha: 0.02),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.08),
                        ],
                  stops: const [0.0, 0.05, 0.95, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 32.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(
                        0xFFC7A87D,
                      ), // Golden/Brownish elegant border
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  widget.zikr.duaText,
                                  style: GoogleFonts.amiri(
                                    fontSize: widget.fontSize,
                                    color: isDone
                                        ? const Color(0xFF8B7355)
                                        : const Color(0xFF2C1E16),
                                    height: 1.9,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 24),
                                if (widget.zikr.reference != null &&
                                    widget.zikr.reference!.isNotEmpty)
                                  Text(
                                    widget.zikr.reference!,
                                    style: GoogleFonts.amiri(
                                      fontSize: widget.fontSize * 0.7,
                                      color: const Color(0xFF5A4328),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildCounterButton(isDone),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFC7A87D), width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'الذكر ${_toArabicNumerals(widget.pageNumber)}',
              style: GoogleFonts.amiri(
                color: const Color(0xFF5A4328),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.category,
            style: GoogleFonts.amiri(
              color: const Color(0xFF5A4328),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDone
              ? const Color(0xFFE8DCC8) // Muted vintage color
              : const Color(0xFF5A4328), // Deep brown/gold
          border: Border.all(color: const Color(0xFFC7A87D), width: 3.0),
          boxShadow: isDone
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF5A4328).withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Text(
          isDone ? 'تم' : _toArabicNumerals(_remainingCount),
          style: GoogleFonts.amiri(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isDone ? const Color(0xFF8B7355) : const Color(0xFFFDF7EF),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final favoriteAsync = ref.watch(
      isFavoriteProvider((type: 'azkar', reference: widget.zikr.id.toString())),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFC7A87D), width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.zikr.duaText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الذكر')),
                  );
                },
                icon: const Icon(Icons.copy, color: Color(0xFF5A4328), size: 20),
                tooltip: 'نسخ الذكر',
              ),
              IconButton(
                onPressed: () async {
                  await ref.read(appDatabaseProvider).toggleFavorite(
                        contentType: 'azkar',
                        primaryReference: widget.zikr.id.toString(),
                        secondaryReference: widget.category,
                        title: widget.zikr.duaText.split('\n').first,
                        contentText: widget.zikr.duaText,
                        source: widget.category,
                      );
                },
                icon: favoriteAsync.when(
                  data: (isFavorite) => Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Theme.of(context).colorScheme.error : const Color(0xFF5A4328),
                    size: 20,
                  ),
                  loading: () => const Icon(Icons.favorite_border, color: Color(0xFF5A4328), size: 20),
                  error: (error, stackTrace) => const Icon(Icons.favorite_border, color: Color(0xFF5A4328), size: 20),
                ),
                tooltip: 'حفظ في المفضلة',
              ),
            ],
          ),
          Text(
            '${_toArabicNumerals(widget.pageNumber)} من ${_toArabicNumerals(widget.totalCount)}',
            style: GoogleFonts.amiri(
              color: const Color(0xFF5A4328),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _toArabicNumerals(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = number.toString();
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }
}
