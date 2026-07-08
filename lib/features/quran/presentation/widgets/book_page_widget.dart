import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_flutter/quran.dart';

class BookPageWidget extends StatelessWidget {
  final int pageNumber;
  final String headerTitle;
  final String headerSubtitle;
  final List<dynamic> verses;
  final Function(int surah, int ayah)? onAyahTapped;

  const BookPageWidget({
    super.key,
    required this.pageNumber,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.verses,
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
        color: const Color(0xFFF0EBE1), // Outer background
        child: Padding(
          padding: EdgeInsets.only(
            left: isRightPage ? leftThickness : 16.0 + leftThickness,
            right: isRightPage ? 16.0 + rightThickness : rightThickness,
            top: 24,
            bottom: 24,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9F6EE), // Antique cream paper color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: isRightPage ? const Offset(-5, 0) : const Offset(5, 0),
                ),
                // Stack of pages illusion
                BoxShadow(
                  color: const Color(0xFFDCD5C6),
                  offset: isRightPage ? Offset(rightThickness, 0) : Offset(-leftThickness, 0),
                )
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
                              Colors.black.withValues(alpha: 0.08), // Spine shadow
                              Colors.transparent,
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.4), // Page edge highlight
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.4), // Page edge highlight
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.08), // Spine shadow
                            ],
                      stops: const [0.0, 0.1, 0.95, 1.0],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFB89E73), // Muted gold classical frame
                          width: 1.5,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFB89E73).withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildHeader(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                        color: const Color(0xFF7A3E3E), // Muted burgundy
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        painter: BookmarkPainter(),
                      ),
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
        border: Border(bottom: BorderSide(color: Color(0xFFB89E73), width: 1.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerSubtitle, // Juz
            style: GoogleFonts.amiri(
              color: const Color(0xFF7A6242),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            headerTitle, // Surah
            style: GoogleFonts.amiri(
              color: const Color(0xFF7A6242),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersesText(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SelectableText.rich(
          TextSpan(
            children: verses.map((verse) {
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
                  if (isBismillah) ...[
                    TextSpan(
                      text: '${Quran.bismillah}\n',
                      style: GoogleFonts.amiri(
                        fontSize: 26,
                        color: const Color(0xFF1C130D),
                        fontWeight: FontWeight.bold,
                        height: 2.2,
                      ),
                    ),
                  ],
                  TextSpan(
                    text: '$text ',
                    style: GoogleFonts.amiri(
                      fontSize: 24, // Authentic readable size
                      color: const Color(0xFF1C130D), // Deep dark brown, softer than pure black
                      height: 2.2, // Balanced line height for Harakat
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '\u06DD', // ۝ Authentic End of Ayah marker
                            style: GoogleFonts.amiri(
                              fontSize: 34,
                              color: const Color(0xFFB89E73),
                              height: 1.0,
                            ),
                          ),
                          Text(
                            _toArabicNumerals(verse.verseNumber),
                            style: GoogleFonts.amiri(
                              fontSize: 13,
                              color: const Color(0xFF5A4328),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          textAlign: TextAlign.justify,
          onTap: () {
            // Tap handling can be refined if using precise text spans
          },
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFB89E73), width: 1.0)),
      ),
      child: Center(
        child: Text(
          _toArabicNumerals(pageNumber),
          style: GoogleFonts.amiri(
            color: const Color(0xFF7A6242),
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

class BookmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF9F6EE) // Match paper color to "cut out" the triangle
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
