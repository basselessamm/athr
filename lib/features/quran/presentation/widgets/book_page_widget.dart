import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_flutter/quran.dart';
import '../../../../core/theme/reading_theme_extension.dart';

class BookPageWidget extends StatefulWidget {
  final int pageNumber;
  final String headerTitle;
  final String headerSubtitle;
  final List<dynamic> verses;
  final double fontSize;
  final Function(int surah, int ayah)? onAyahTapped;

  const BookPageWidget({
    super.key,
    required this.pageNumber,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.verses,
    required this.fontSize,
    this.onAyahTapped,
  });

  @override
  State<BookPageWidget> createState() => _BookPageWidgetState();
}

class _BookPageWidgetState extends State<BookPageWidget> {
  final Map<String, TapGestureRecognizer> _recognizers = {};

  @override
  void initState() {
    super.initState();
    _initRecognizers();
  }

  @override
  void didUpdateWidget(covariant BookPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.verses != widget.verses) {
      _disposeRecognizers();
      _initRecognizers();
    }
  }

  void _initRecognizers() {
    for (var verse in widget.verses) {
      final key = '${verse.surahNumber}_${verse.verseNumber}';
      final recognizer = TapGestureRecognizer()
        ..onTap = () {
          if (widget.onAyahTapped != null) {
            widget.onAyahTapped!(verse.surahNumber, verse.verseNumber);
          }
        };
      _recognizers[key] = recognizer;
    }
  }

  void _disposeRecognizers() {
    for (var recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final readingTheme = theme.extension<ReadingThemeExtension>()!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: readingTheme.pageTextureColor,
        child: Column(
          children: [
            _buildHeader(readingTheme),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: _buildVersesText(context, readingTheme),
              ),
            ),
            _buildFooter(readingTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ReadingThemeExtension readingTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: readingTheme.borderColor.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.headerSubtitle, // Juz
            style: GoogleFonts.amiri(
              color: readingTheme.borderColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.headerTitle, // Surah
            style: GoogleFonts.amiri(
              color: readingTheme.borderColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersesText(
    BuildContext context,
    ReadingThemeExtension readingTheme,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Text.rich(
        TextSpan(
          children: widget.verses.map((verse) {
            final isBismillah =
                verse.verseNumber == 1 &&
                verse.surahNumber != 1 &&
                verse.surahNumber != 9;

            String text = verse.text;
            if (isBismillah && text.startsWith(Quran.bismillah)) {
              text = text.replaceFirst(Quran.bismillah, '').trim();
            }

            final key = '${verse.surahNumber}_${verse.verseNumber}';
            final recognizer = _recognizers[key];

            return TextSpan(
              recognizer: recognizer,
              children: [
                if (isBismillah) ...[
                  TextSpan(
                    text: '${Quran.bismillah}\n',
                    style: GoogleFonts.amiri(
                      fontSize: widget.fontSize + 2,
                      color: readingTheme.textColor,
                      fontWeight: FontWeight.bold,
                      height: 2.2,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                    recognizer: recognizer,
                  ),
                ],
                TextSpan(
                  text: '$text ',
                  style: GoogleFonts.amiri(
                    fontSize: widget.fontSize,
                    color: readingTheme.textColor,
                    height: 2.2,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                  recognizer: recognizer,
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '\u06DD', // ۝ End of Ayah marker
                          style: GoogleFonts.amiri(
                            fontSize: 34,
                            color: readingTheme.borderColor,
                            height: 1.0,
                            textBaseline: TextBaseline.alphabetic,
                          ),
                        ),
                        Text(
                          _toArabicNumerals(verse.verseNumber),
                          style: GoogleFonts.amiri(
                            fontSize: 13,
                            color: readingTheme.textColor.withValues(
                              alpha: 0.8,
                            ),
                            fontWeight: FontWeight.bold,
                            textBaseline: TextBaseline.alphabetic,
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
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildFooter(ReadingThemeExtension readingTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: readingTheme.borderColor.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Text(
          _toArabicNumerals(widget.pageNumber),
          style: GoogleFonts.amiri(
            color: readingTheme.borderColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            textBaseline: TextBaseline.alphabetic,
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
