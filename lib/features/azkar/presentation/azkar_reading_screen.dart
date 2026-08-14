import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/widgets/premium_quran_flip_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/azkar/application/zikr_repetition.dart';
import 'package:athr/features/azkar/providers/azkar_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/core/memory/domain/memory_contracts.dart';
import 'package:athr/features/memory_capture/presentation/capture_flow.dart';

class AzkarReadingScreen extends ConsumerStatefulWidget {
  final String category;
  final int? focusItemId;

  const AzkarReadingScreen({
    super.key,
    required this.category,
    this.focusItemId,
  });

  @override
  ConsumerState<AzkarReadingScreen> createState() => _AzkarReadingScreenState();
}

class _AzkarReadingScreenState extends ConsumerState<AzkarReadingScreen> {
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

  int _focusIndex(List<Dua> azkar) {
    final focusId = widget.focusItemId;
    if (focusId == null) return 0;
    final index = azkar.indexWhere((item) => item.id == focusId);
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final azkarAsync = ref.watch(azkarByCategoryProvider(widget.category));
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF2C241C),
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF2C241C),
        foregroundColor: const Color(0xFFF9F6EE),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFFF9F6EE),
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: azkarAsync.when(
            data: (azkar) {
              if (azkar.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد أذكار في هذا التصنيف.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return PremiumQuranFlipWidget(
                initialIndex: _focusIndex(azkar),
                itemCount: azkar.length,
                semanticPageLabel: (index, total) =>
                    'الذكر ${index + 1} من $total في ${widget.category}',
                endPage: Container(
                  color: const Color(0xFFFDF7EF),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified,
                        size: 80,
                        color: Color(0xFFC7A87D),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'تم بحمد الله',
                        style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFF5A4328),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.category,
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
                          'عودة للأذكار',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, index) {
                  final zikr = azkar[index];
                  return _PremiumZikrPage(
                    key: ValueKey(zikr.id),
                    zikr: zikr,
                    pageNumber: index + 1,
                    totalCount: azkar.length,
                    category: widget.category,
                    fontSize: fontSize,
                    onCapturePressed: () {
                      showCaptureSheet(
                        context,
                        source: CaptureSource(
                          reference: SourceReference.azkar(
                            itemId: zikr.id.toString(),
                            category: widget.category,
                            sourceLabel: 'الأذكار',
                            sourceCitation: zikr.reference,
                          ),
                          displayText: zikr.duaText,
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFFC7A87D)),
            ),
            error: (err, st) => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'تعذر فتح الأذكار الآن. حاول العودة بعد قليل.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFF9F6EE)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumZikrPage extends StatefulWidget {
  final Dua zikr;
  final int pageNumber;
  final int totalCount;
  final String category;
  final double fontSize;
  final VoidCallback? onCapturePressed;

  const _PremiumZikrPage({
    super.key,
    required this.zikr,
    required this.pageNumber,
    required this.totalCount,
    required this.category,
    required this.fontSize,
    this.onCapturePressed,
  });

  @override
  State<_PremiumZikrPage> createState() => _PremiumZikrPageState();
}

class _PremiumZikrPageState extends State<_PremiumZikrPage>
    with AutomaticKeepAliveClientMixin {
  late int _remainingCount;
  late ZikrRepetition _repetition;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _repetition = repetitionFromStoredText(widget.zikr.duaText);
    _remainingCount = _repetition.target;
  }

  void _resetCounter() {
    setState(() {
      _remainingCount = _repetition.target;
    });
    HapticFeedback.selectionClick();
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
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFDF7EF), // Base paper color
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
                            const SizedBox(height: 28),
                            if (widget.zikr.reference != null &&
                                widget.zikr.reference!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2E9DC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFC7A87D,
                                    ).withValues(alpha: 0.55),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'المرجع',
                                      style: GoogleFonts.cairo(
                                        fontSize: 12,
                                        color: const Color(0xFF6F5A42),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.zikr.reference!,
                                      style: GoogleFonts.amiri(
                                        fontSize: widget.fontSize * 0.72,
                                        color: const Color(0xFF5A4328),
                                        fontWeight: FontWeight.w700,
                                        height: 1.45,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildCounterButton(isDone),
                  if (_remainingCount != _repetition.target)
                    TextButton.icon(
                      onPressed: _resetCounter,
                      icon: const Icon(Icons.restart_alt, size: 18),
                      label: const Text('إعادة العداد'),
                    ),
                  _buildFooter(),
                ],
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
          IconButton(
            onPressed: widget.onCapturePressed,
            tooltip: 'اترك أثرًا',
            icon: const Icon(Icons.bookmark_add_outlined),
            color: const Color(0xFF5A4328),
          ),
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
    final hasExplicitCount = _repetition.isExplicitInText;
    final label = isDone
        ? 'تمت قراءة الذكر. يمكنك إعادة العداد متى شئت.'
        : hasExplicitCount
        ? '${_toArabicNumerals(_remainingCount)} من ${_toArabicNumerals(_repetition.target)}. اضغط بعد كل تكرار.'
        : 'تأكيد قراءة الذكر. اضغط عند الإتمام.';
    final helper = hasExplicitCount
        ? 'العدد المبيّن في النص: ${_toArabicNumerals(_repetition.target)}'
        : 'لا يرد عدد صريح في هذه المادة. استخدم الزر لتأكيد القراءة فقط.';

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 12),
      child: Column(
        children: [
          Text(
            helper,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 12,
              height: 1.45,
              color: const Color(0xFF6F5A42),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hasExplicitCount) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value:
                    (_repetition.target - _remainingCount) / _repetition.target,
                minHeight: 5,
                color: const Color(0xFF5A4328),
                backgroundColor: const Color(0xFFE8DCC8),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Semantics(
            button: true,
            label: label,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _handleTap,
                customBorder: const CircleBorder(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? const Color(0xFFE8DCC8)
                        : const Color(0xFF5A4328),
                    border: Border.all(
                      color: const Color(0xFFC7A87D),
                      width: 3,
                    ),
                    boxShadow: isDone
                        ? []
                        : [
                            BoxShadow(
                              color: const Color(
                                0xFF5A4328,
                              ).withValues(alpha: 0.28),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isDone
                        ? 'تم'
                        : hasExplicitCount
                        ? _toArabicNumerals(_remainingCount)
                        : 'قرأت',
                    style: GoogleFonts.amiri(
                      fontSize: hasExplicitCount ? 32 : 23,
                      fontWeight: FontWeight.bold,
                      color: isDone
                          ? const Color(0xFF8B7355)
                          : const Color(0xFFFDF7EF),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFC7A87D), width: 1.5)),
      ),
      child: Center(
        child: Text(
          '${_toArabicNumerals(widget.pageNumber)} / ${_toArabicNumerals(widget.totalCount)}',
          style: GoogleFonts.amiri(
            color: const Color(0xFF5A4328),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
