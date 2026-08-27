import 'package:flutter/material.dart';

import 'package:midrar/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:midrar/core/widgets/premium_quran_flip_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/features/azkar/providers/azkar_providers.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';
import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/features/memory_capture/presentation/capture_flow.dart';

/// Azkar reading experience (schema v8): one zikr per page, each with its
/// own honestly-parsed counter, time-marker chips, a persistent daily
/// session, and category references at the end.
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

enum _TimeFilter { all, morning, evening }

class _AzkarReadingScreenState extends ConsumerState<AzkarReadingScreen> {
  _TimeFilter _filter = _TimeFilter.all;

  List<Zikr> _applyFilter(List<Zikr> zikrList) {
    switch (_filter) {
      case _TimeFilter.all:
        return zikrList;
      case _TimeFilter.morning:
        return zikrList
            .where((z) => z.timeMarker != 'evening')
            .toList(growable: false);
      case _TimeFilter.evening:
        return zikrList
            .where((z) => z.timeMarker != 'morning')
            .toList(growable: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final zikrAsync = ref.watch(zikrByCategoryProvider(widget.category));
    final referencesAsync = ref.watch(azkarByCategoryProvider(widget.category));
    final fontSize = ref.watch(fontSizeProvider);
    final session = ref.watch(azkarSessionProvider(widget.category));

    return Scaffold(
      backgroundColor: AppColors.mushafBackground,
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.mushafBackground,
        foregroundColor: AppColors.mushafPaperAlt,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: AppColors.mushafPaperAlt,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SafeArea(
        child: zikrAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.mushafGold),
          ),
          error: (err, st) => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'تعذر فتح الأذكار الآن. حاول العودة بعد قليل.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.mushafPaperAlt),
              ),
            ),
          ),
          data: (zikrList) {
            if (zikrList.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد أذكار في هذا التصنيف.',
                  style: TextStyle(color: AppColors.mushafPaperAlt),
                ),
              );
            }

            final visible = _applyFilter(zikrList);
            final completedInVisible = visible
                .where((z) => session.completedIds.contains(z.id))
                .length;
            final hasMarkers = zikrList.any(
              (z) => z.timeMarker != null,
            );

            return Column(
              children: [
                _ProgressHeader(
                  completed: completedInVisible,
                  total: visible.length,
                  category: widget.category,
                ),
                if (hasMarkers)
                  _TimeFilterChips(
                    selected: _filter,
                    counts: _filterCounts(zikrList),
                    onChanged: (filter) => setState(() => _filter = filter),
                  ),
                Expanded(
                  child: visible.isEmpty
                      ? Center(
                          child: Text(
                            'لا توجد أذكار ضمن هذا الوقت.',
                            style: GoogleFonts.cairo(
                              color: AppColors.mushafPaperAlt,
                            ),
                          ),
                        )
                      : PremiumQuranFlipWidget(
                          key: ValueKey(_filter),
                          initialIndex: _initialIndex(visible, session),
                          itemCount: visible.length,
                          semanticPageLabel: (index, total) =>
                              'الذكر ${index + 1} من $total في ${widget.category}',
                          endPage: _CompletionPage(
                            category: widget.category,
                            references: referencesAsync.valueOrNull
                                ?.map((d) => d.reference)
                                .whereType<String>()
                                .toList(),
                          ),
                          itemBuilder: (context, index) {
                            final zikr = visible[index];
                            return _ZikrPage(
                              key: ValueKey(zikr.id),
                              zikr: zikr,
                              pageNumber: index + 1,
                              totalCount: visible.length,
                              category: widget.category,
                              fontSize: fontSize,
                              initiallyCompleted: session.completedIds
                                  .contains(zikr.id),
                              onCompleted: (done) {
                                final notifier = ref.read(
                                  azkarSessionProvider(widget.category)
                                      .notifier,
                                );
                                if (done) {
                                  notifier.markCompleted(zikr.id);
                                } else {
                                  notifier.markUncompleted(zikr.id);
                                }
                              },
                              onCapturePressed: () {
                                showCaptureSheet(
                                  context,
                                  source: CaptureSource(
                                    reference: SourceReference.azkar(
                                      itemId: zikr.id.toString(),
                                      category: widget.category,
                                      sourceLabel: 'الأذكار',
                                      sourceCitation: zikr.repetitionLabel,
                                    ),
                                    displayText: zikr.zikrText,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  int _initialIndex(List<Zikr> visible, AzkarSessionState session) {
    final focusId = widget.focusItemId;
    if (focusId != null) {
      final index = visible.indexWhere((z) => z.id == focusId);
      if (index >= 0) return index;
    }
    // Resume at the first incomplete zikr.
    final firstIncomplete = visible.indexWhere(
      (z) => !session.completedIds.contains(z.id),
    );
    return firstIncomplete < 0 ? 0 : firstIncomplete;
  }

  ({int all, int morning, int evening}) _filterCounts(List<Zikr> zikrList) {
    final morning = zikrList.where((z) => z.timeMarker != 'evening').length;
    final evening = zikrList.where((z) => z.timeMarker != 'morning').length;
    return (all: zikrList.length, morning: morning, evening: evening);
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.completed,
    required this.total,
    required this.category,
  });

  final int completed;
  final int total;
  final String category;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  total == 0
                      ? category
                      : 'أكملت ${_toArabic(completed)} من ${_toArabic(total)}',
                  style: GoogleFonts.cairo(
                    color: AppColors.mushafPaperAlt,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              color: AppColors.mushafGold,
              backgroundColor: AppColors.mushafBackgroundDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeFilterChips extends StatelessWidget {
  const _TimeFilterChips({
    required this.selected,
    required this.counts,
    required this.onChanged,
  });

  final _TimeFilter selected;
  final ({int all, int morning, int evening}) counts;
  final ValueChanged<_TimeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget chip(_TimeFilter value, String label, int count) {
      final isSelected = selected == value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ChoiceChip(
          label: Text('$label · ${_toArabic(count)}'),
          selected: isSelected,
          onSelected: (_) => onChanged(value),
          labelStyle: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? AppColors.mushafBackground
                : AppColors.mushafPaperAlt,
          ),
          selectedColor: AppColors.mushafGold,
          backgroundColor: AppColors.mushafBackgroundDeep,
          side: const BorderSide(color: AppColors.mushafInkFaint),
          showCheckmark: false,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 2, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          chip(_TimeFilter.all, 'الكل', counts.all),
          chip(_TimeFilter.morning, 'الصباح', counts.morning),
          chip(_TimeFilter.evening, 'المساء', counts.evening),
        ],
      ),
    );
  }
}

class _ZikrPage extends StatefulWidget {
  const _ZikrPage({
    super.key,
    required this.zikr,
    required this.pageNumber,
    required this.totalCount,
    required this.category,
    required this.fontSize,
    required this.initiallyCompleted,
    required this.onCompleted,
    this.onCapturePressed,
  });

  final Zikr zikr;
  final int pageNumber;
  final int totalCount;
  final String category;
  final double fontSize;
  final bool initiallyCompleted;
  final ValueChanged<bool> onCompleted;
  final VoidCallback? onCapturePressed;

  @override
  State<_ZikrPage> createState() => _ZikrPageState();
}

class _ZikrPageState extends State<_ZikrPage>
    with AutomaticKeepAliveClientMixin {
  late int _remaining;
  late bool _done;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final target = widget.zikr.repetitionCount ?? 1;
    _done = widget.initiallyCompleted;
    _remaining = _done ? 0 : target;
  }

  void _handleTap() {
    if (_done) return;
    if (_remaining > 0) {
      setState(() => _remaining--);
      if (_remaining > 0) {
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.heavyImpact();
        setState(() => _done = true);
        widget.onCompleted(true);
      }
    }
  }

  void _reset() {
    setState(() {
      _remaining = widget.zikr.repetitionCount ?? 1;
      _done = false;
    });
    widget.onCompleted(false);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isRightPage = widget.pageNumber % 2 != 0;
    final hasExplicitCount = widget.zikr.repetitionCount != null;
    final target = widget.zikr.repetitionCount ?? 1;

    final counterLabel = _done
        ? 'تم'
        : hasExplicitCount
        ? _toArabic(_remaining)
        : 'قرأت';
    final helper = _done
        ? 'تمت قراءة الذكر. يمكنك إعادة العداد متى شئت.'
        : hasExplicitCount
        ? '${_toArabic(_remaining)} من ${_toArabic(target)}. اضغط بعد كل تكرار.'
        : 'لا يرد عدد صريح في هذه المادة. استخدم الزر لتأكيد القراءة فقط.';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.mushafPaper,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.mushafGold,
                  width: 2.0,
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.zikr.repetitionLabel != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  '(${widget.zikr.repetitionLabel!})',
                                  style: GoogleFonts.cairo(
                                    fontSize: widget.fontSize * 0.6,
                                    color: AppColors.mushafInkSoft,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            Text(
                              widget.zikr.zikrText,
                              style: GoogleFonts.amiri(
                                fontSize: widget.fontSize,
                                color: _done
                                    ? AppColors.mushafInkSoft
                                    : AppColors.mushafInk,
                                height: 1.9,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      8,
                      16,
                      8,
                    ),
                    child: Column(
                      children: [
                        Text(
                          helper,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            height: 1.45,
                            color: AppColors.mushafInkFaint,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (hasExplicitCount) ...[
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: (target - _remaining) / target,
                              minHeight: 4,
                              color: AppColors.mushafInkStrong,
                              backgroundColor: AppColors.mushafBorder,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Semantics(
                          button: true,
                          label: helper,
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: _handleTap,
                              customBorder: const CircleBorder(),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _done
                                      ? AppColors.mushafBorder
                                      : AppColors.mushafInkStrong,
                                  border: Border.all(
                                    color: AppColors.mushafGold,
                                    width: 3,
                                  ),
                                  boxShadow: _done
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: AppColors.mushafInkStrong
                                                .withValues(alpha: 0.28),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  counterLabel,
                                  style: GoogleFonts.amiri(
                                    fontSize: hasExplicitCount ? 30 : 22,
                                    fontWeight: FontWeight.bold,
                                    color: _done
                                        ? AppColors.mushafInkSoft
                                        : AppColors.mushafPaper,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_done || _remaining != target)
                          TextButton.icon(
                            onPressed: _reset,
                            icon: const Icon(Icons.restart_alt, size: 18),
                            label: const Text('إعادة العداد'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.mushafInkFaint,
                            ),
                          ),
                      ],
                    ),
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
    final marker = widget.zikr.timeMarker;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.mushafGold, width: 1.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            'الذكر ${_toArabic(widget.pageNumber)}',
            style: GoogleFonts.amiri(
              color: AppColors.mushafInkStrong,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (marker != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.mushafPaperMuted,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: AppColors.mushafGold.withValues(alpha: 0.6),
                ),
              ),
              child: Text(
                marker == 'morning' ? 'صباحاً' : 'مساءً',
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: AppColors.mushafInkFaint,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            onPressed: widget.onCapturePressed,
            tooltip: 'اترك أثرًا',
            icon: const Icon(Icons.bookmark_add_outlined),
            color: AppColors.mushafInkStrong,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.mushafGold, width: 1.5),
        ),
      ),
      child: Center(
        child: Text(
          '${_toArabic(widget.pageNumber)} / ${_toArabic(widget.totalCount)}',
          style: GoogleFonts.amiri(
            color: AppColors.mushafInkStrong,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _CompletionPage extends StatelessWidget {
  const _CompletionPage({required this.category, required this.references});

  final String category;
  final List<String>? references;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mushafPaper,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.verified,
              size: 76,
              color: AppColors.mushafGold,
            ),
            const SizedBox(height: 20),
            const Text(
              'تم بحمد الله',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: AppColors.mushafInkStrong,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.mushafInkSoft,
              ),
            ),
            const SizedBox(height: 28),
            if (references != null && references!.isNotEmpty) ...[
              const Text(
                'المراجع',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mushafInkFaint,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.mushafPaperMuted,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.mushafGold.withValues(alpha: 0.55),
                  ),
                ),
                child: Text(
                  references!.join('\n'),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mushafInkStrong,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
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
              child: const Text('عودة للأذكار', style: TextStyle(fontSize: 17)),
            ),
          ],
        ),
      ),
    );
  }
}

String _toArabic(int number) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  var result = number.toString();
  for (var i = 0; i < english.length; i++) {
    result = result.replaceAll(english[i], arabic[i]);
  }
  return result;
}
