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
    // Determine page side for spine shadow
    // In Arabic, odd pages are on the right (spine on the left)
    // Even pages are on the left (spine on the right)
    final bool isRightPage = pageNumber % 2 != 0;

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
                      Colors.black.withValues(
                        alpha: 0.08,
                      ), // Spine shadow on left
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.02),
                    ]
                  : [
                      Colors.black.withValues(alpha: 0.02),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(
                        alpha: 0.08,
                      ), // Spine shadow on right
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
          Text(
            headerSubtitle, // e.g. "الجزء الأول"
            style: GoogleFonts.amiri(
              color: const Color(0xFF5A4328),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            headerTitle, // e.g. "سورة البقرة"
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

  Widget _buildVersesText(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SelectableText.rich(
          TextSpan(
            children: verses.map((verse) {
              final isBismillah =
                  verse.verseNumber == 1 &&
                  verse.surahNumber != 1 && // Fatihah has it as verse 1
                  verse.surahNumber != 9; // Tawbah has no bismillah

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
                        fontSize: 24,
                        color: const Color(0xFF2C1E16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  TextSpan(
                    text: '$text ',
                    style: GoogleFonts.amiri(
                      fontSize: 22,
                      color: const Color(0xFF2C1E16),
                      height: 1.9,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons
                                .brightness_2_outlined, // Fallback ornamental shape
                            size: 32,
                            color: const Color(
                              0xFFC7A87D,
                            ).withValues(alpha: 0.5),
                          ),
                          Text(
                            _toArabicNumerals(verse.verseNumber),
                            style: GoogleFonts.amiri(
                              fontSize: 14,
                              color: const Color(0xFF5A4328),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const TextSpan(text: ' '),
                ],
              );
            }).toList(),
          ),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
        );
      },
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
          _toArabicNumerals(pageNumber),
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
