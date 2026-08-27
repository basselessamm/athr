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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: AppColors.mushafPaperEdge, // Outer background
        child: Padding(
          padding: EdgeInsets.only(
            left: isRightPage ? leftThickness : 16.0 + leftThickness,
            right: isRightPage ? 16.0 + rightThickness : rightThickness,
            top: 24,
            bottom: 24,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.mushafPaperAlt, // Antique cream paper color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: isRightPage
                      ? const Offset(-5, 0)
                      : const Offset(5, 0),
                ),
                // Stack of pages illusion
                BoxShadow(
                  color: AppColors.mushafBorderSoft,
                  offset: isRightPage
                      ? Offset(rightThickness, 0)
                      : Offset(-leftThickness, 0),
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
                      horizontal: 16.0,
                      vertical: 24.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(
                            0xFFB89E73,
                          ), // Muted gold classical frame
                          width: 1.5,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(
                              0xFFB89E73,
                            ).withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildHeader(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                child: _buildVersesText(context),
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

  Widget _buildVersesText(BuildContext context) {
    return _AyahRichText(
      verses: verses,
      textScale: textScale,
      highlightedAyah: highlightedAyah,
      onAyahTapped: onAyahTapped,
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

  const _AyahRichText({
    required this.verses,
    required this.textScale,
    required this.highlightedAyah,
    required this.onAyahTapped,
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
    return Semantics(
      label: 'نص الصفحة. اضغط على الآية لفتح خياراتها.',
      child: RichText(
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
                      fontSize: 26 * widget.textScale,
                      color: AppColors.mushafInk,
                      fontWeight: FontWeight.bold,
                      height: 2.2,
                    ),
                  ),
                TextSpan(
                  text: '$text ',
                  recognizer: _recognizerFor(verse),
                  style: GoogleFonts.amiri(
                    fontSize: 24 * widget.textScale,
                    color: AppColors.mushafInk,
                    height: 2.2,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '\u06DD',
                              style: GoogleFonts.amiri(
                                fontSize: 34 * widget.textScale,
                                color: AppColors.mushafGoldMuted,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              _toArabicNumerals(verse.verseNumber),
                              style: GoogleFonts.amiri(
                                fontSize: 13 * widget.textScale,
                                color: AppColors.mushafInkStrong,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        textAlign: TextAlign.justify,
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
