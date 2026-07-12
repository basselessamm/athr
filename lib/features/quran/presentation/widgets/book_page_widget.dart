import 'dart:math' show cos, sin;

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
  final int? highlightSurah;
  final int? highlightAyah;

  const BookPageWidget({
    super.key,
    required this.pageNumber,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.verses,
    required this.fontSize,
    this.onAyahTapped,
    this.highlightSurah,
    this.highlightAyah,
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
                    backgroundColor: (widget.highlightSurah == verse.surahNumber && widget.highlightAyah == verse.verseNumber)
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                        : null,
                  ),
                  recognizer: recognizer,
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _AyahNumberMarker(
                      number: verse.verseNumber,
                      size: 36,
                      color: readingTheme.borderColor,
                      textColor: readingTheme.textColor,
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

/// A custom ornate circular marker for Ayah numbers,
/// designed to mimic the traditional markers found in printed Qurans.
class _AyahNumberMarker extends StatelessWidget {
  final int number;
  final double size;
  final Color color;
  final Color textColor;

  const _AyahNumberMarker({
    required this.number,
    required this.size,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AyahMarkerPainter(color: color),
        child: Center(
          child: Text(
            _toArabicNumerals(number),
            style: GoogleFonts.amiri(
              fontSize: size * 0.36,
              color: textColor,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
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

class _AyahMarkerPainter extends CustomPainter {
  final Color color;

  _AyahMarkerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw main ornate hexagram (Star of David style outline)
    // This mimics the classic printed Quran ayah symbol
    final path = Path();
    final points = <Offset>[];
    const triangleCount = 6;

    for (int i = 0; i < triangleCount * 2; i++) {
      final angle = (i * 30 - 90) * 3.141592653589793 / 180;
      final r = i.isEven ? radius * 0.92 : radius * 0.5;
      points.add(Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      ));
    }

    // Connect outer points to create the ornate flower/star shape
    for (int i = 0; i < triangleCount; i++) {
      final outer = points[i * 2];
      final nextOuter = points[((i + 1) % triangleCount) * 2];
      final inner = points[i * 2 + 1];

      if (i == 0) {
        path.moveTo(outer.dx, outer.dy);
      }
      path.lineTo(inner.dx, inner.dy);
      path.lineTo(nextOuter.dx, nextOuter.dy);
    }
    path.close();
    canvas.drawPath(path, paint);

    // Draw inner circle for extra detail
    final innerCirclePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(center, radius * 0.35, innerCirclePaint);

    // Draw small decorative dots at each outer vertex
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    for (int i = 0; i < triangleCount; i++) {
      final angle = (i * 60 - 90) * 3.141592653589793 / 180;
      final dotCenter = Offset(
        center.dx + radius * 0.92 * cos(angle),
        center.dy + radius * 0.92 * sin(angle),
      );
      canvas.drawCircle(dotCenter, 1.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
