import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:midrar/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

class BookPageWidget extends StatelessWidget {
  final int pageNumber;
  final String headerTitle;
  final String headerSubtitle;
  final List<dynamic> verses;
  final double textScale;
  final int? highlightedAyah;
  final Function(int surah, int ayah)? onAyahTapped;

  const BookPageWidget({
    super.key,
    required this.pageNumber,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.verses,
    this.textScale = 1,
    this.highlightedAyah,
    this.onAyahTapped,
  });

  @override
  Widget build(BuildContext context) {
    // In Arabic (RTL), page 1 is on the right, page 2 on the left.
    final bool isRightPage = pageNumber % 2 != 0;

    // Dynamic book thickness calculation (Total Quran pages = 604)
    final double rightThickness = (pageNumber / 604) * 8.0;
    final double leftThickness = ((604 - pageNumber) / 604) * 8.0;

    final outerBg = Theme.of(context).scaffoldBackgroundColor;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: outerBg, // Outer background matches app theme exactly
        child: Padding(
          padding: EdgeInsets.only(
            left: isRightPage ? leftThickness + 4.0 : 8.0 + leftThickness,
            right: isRightPage ? 8.0 + rightThickness : rightThickness + 4.0,
            top: 4,
            bottom: 4,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.mushafPaperAlt, // Antique cream paper color
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: isRightPage
                      ? const Offset(-3, 2)
                      : const Offset(3, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Inner page background gradient and texture
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: isRightPage
                          ? [
                              Colors.black.withValues(
                                alpha: 0.08,
                              ), // Spine shadow
                              Colors.transparent,
                              Colors.transparent,
                              Colors.white.withValues(
                                alpha: 0.4,
                              ), // Page edge highlight
                            ]
                          : [
                              Colors.white.withValues(
                                alpha: 0.4,
                              ), // Page edge highlight
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withValues(
                                alpha: 0.08,
                              ), // Spine shadow
                            ],
                      stops: const [0.0, 0.1, 0.95, 1.0],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 6.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.mushafGoldMuted,
                          width: 1.5,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.mushafGoldMuted.withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildHeader(),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final isFatihah = pageNumber == 1;
                                  return Scrollbar(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 8.0,
                                      ),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: constraints.maxHeight,
                                        ),
                                        child: isFatihah
                                            ? Center(
                                                child: _buildVersesText(
                                                  context,
                                                  isFatihah: true,
                                                ),
                                              )
                                            : _buildVersesText(
                                                context,
                                                isFatihah: false,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            _buildFooter(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Elegant Bookmark Ribbon (only on right page for aesthetics, or based on last read)
                if (isRightPage)
                  Positioned(
                    top: -10,
                    right: 40,
                    child: Container(
                      width: 16,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.mushafMarkerRed, // Muted burgundy
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: CustomPaint(painter: BookmarkPainter()),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.mushafGoldMuted, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerSubtitle, // Juz
            style: GoogleFonts.amiri(
              color: AppColors.mushafInkFaint,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            headerTitle, // Surah
            style: GoogleFonts.amiri(
              color: AppColors.mushafInkFaint,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersesText(BuildContext context, {bool isFatihah = false}) {
    return _AyahRichText(
      verses: verses,
      textScale: textScale,
      highlightedAyah: highlightedAyah,
      onAyahTapped: onAyahTapped,
      isFatihah: isFatihah,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.mushafGoldMuted, width: 1.0)),
      ),
      child: Center(
        child: Text(
          _toArabicNumerals(pageNumber),
          style: GoogleFonts.amiri(
            color: AppColors.mushafInkFaint,
            fontSize: 14,
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

class _AyahRichText extends StatefulWidget {
  final List<dynamic> verses;
  final double textScale;
  final int? highlightedAyah;
  final Function(int surah, int ayah)? onAyahTapped;
  final bool isFatihah;

  const _AyahRichText({
    required this.verses,
    required this.textScale,
    required this.highlightedAyah,
    required this.onAyahTapped,
    this.isFatihah = false,
  });

  @override
  State<_AyahRichText> createState() => _AyahRichTextState();
}

class _AyahRichTextState extends State<_AyahRichText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void didUpdateWidget(covariant _AyahRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeRecognizers();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  TapGestureRecognizer _recognizerFor(dynamic verse) {
    final recognizer = TapGestureRecognizer()
      ..onTap = widget.onAyahTapped == null
          ? null
          : () => widget.onAyahTapped!(verse.surahNumber, verse.verseNumber);
    _recognizers.add(recognizer);
    return recognizer;
  }

  @override
  Widget build(BuildContext context) {
    _disposeRecognizers();
    final effectiveFontSize = widget.isFatihah
        ? 23.5 * widget.textScale
        : 22.0 * widget.textScale;
    final effectiveLineHeight = widget.isFatihah ? 1.95 : 1.90;

    return Semantics(
      label: 'نص الصفحة. اضغط على الآية لفتح خياراتها.',
      child: RichText(
        textAlign: widget.isFatihah ? TextAlign.center : TextAlign.justify,
        text: TextSpan(
          children: widget.verses.map((verse) {
            final isBismillah =
                verse.verseNumber == 1 &&
                verse.surahNumber != 1 &&
                verse.surahNumber != 9;

            String text = verse.text;
            if (isBismillah && text.startsWith(Quran.bismillah)) {
              text = text.replaceFirst(Quran.bismillah, '').trim();
            }

            return TextSpan(
              children: [
                if (isBismillah)
                  TextSpan(
                    text: '${Quran.bismillah}\n',
                    style: GoogleFonts.amiri(
                      fontSize: 24 * widget.textScale,
                      color: AppColors.mushafInk,
                      fontWeight: FontWeight.bold,
                      height: 2.0,
                    ),
                  ),
                TextSpan(
                  text: '$text ',
                  recognizer: _recognizerFor(verse),
                  style: GoogleFonts.amiri(
                    fontSize: effectiveFontSize,
                    color: AppColors.mushafInk,
                    height: effectiveLineHeight,
                    backgroundColor: verse.verseNumber == widget.highlightedAyah
                        ? AppColors.mushafGold.withValues(alpha: 0.20)
                        : null,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Semantics(
                    container: true,
                    button: true,
                    label:
                        'خيارات الآية ${_toArabicNumerals(verse.verseNumber)}',
                    child: GestureDetector(
                      key: ValueKey(
                        'ayah-marker-${verse.surahNumber}-${verse.verseNumber}',
                      ),
                      onTap: widget.onAyahTapped == null
                          ? null
                          : () => widget.onAyahTapped!(
                              verse.surahNumber,
                              verse.verseNumber,
                            ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3.5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.mushafGoldMuted,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.mushafGold.withValues(alpha: 0.10),
                        ),
                        child: Text(
                          _toArabicNumerals(verse.verseNumber),
                          style: GoogleFonts.amiri(
                            fontSize: 13 * widget.textScale,
                            color: AppColors.mushafInkStrong,
                            fontWeight: FontWeight.bold,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
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

class BookmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          AppColors.mushafPaperAlt // Match paper color to "cut out" the triangle
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, size.height - 10)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height + 1) // cover bottom edge
      ..lineTo(0, size.height + 1)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
