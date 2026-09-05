import 'package:midrar/features/quran/presentation/widgets/book_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

class _VerseFixture {
  const _VerseFixture({
    required this.surahNumber,
    required this.verseNumber,
    required this.text,
  });

  final int surahNumber;
  final int verseNumber;
  final String text;
}

void main() {
  testWidgets('opens verse actions through the explicit ayah-number target', (
    tester,
  ) async {
    int? selectedSurah;
    int? selectedAyah;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BookPageWidget(
            pageNumber: 1,
            headerTitle: 'سورة الفاتحة',
            headerSubtitle: 'الجزء 1',
            verses: const [
              _VerseFixture(
                surahNumber: 1,
                verseNumber: 1,
                text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              ),
            ],
            onAyahTapped: (surah, ayah) {
              selectedSurah = surah;
              selectedAyah = ayah;
            },
          ),
        ),
      ),
    );

    final marker = find.textContaining('﴿١﴾');
    expect(marker, findsOneWidget);

    await tester.tap(marker);
    await tester.pump();

    expect(selectedSurah, 1);
    expect(selectedAyah, 1);
  });

  testWidgets('renders markers on justified page without error', (tester) async {
    int? tappedAyah;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 700,
            child: BookPageWidget(
              pageNumber: 2,
              headerTitle: 'سورة البقرة',
              headerSubtitle: 'الجزء 1',
              verses: const [
                _VerseFixture(
                  surahNumber: 2,
                  verseNumber: 1,
                  text: 'الم',
                ),
                _VerseFixture(
                  surahNumber: 2,
                  verseNumber: 2,
                  text: 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
                ),
                _VerseFixture(
                  surahNumber: 2,
                  verseNumber: 3,
                  text: 'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ',
                ),
                _VerseFixture(
                  surahNumber: 2,
                  verseNumber: 4,
                  text: 'وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ',
                ),
                _VerseFixture(
                  surahNumber: 2,
                  verseNumber: 5,
                  text: 'أُولَٰئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ ۖ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ',
                ),
              ],
              onAyahTapped: (surah, ayah) {
                tappedAyah = ayah;
              },
            ),
          ),
        ),
      ),
    );

    for (int i = 1; i <= 5; i++) {
      final arabicNum = ['٠', '١', '٢', '٣', '٤', '٥'][i];
      expect(find.textContaining('﴿$arabicNum﴾'), findsOneWidget);
    }

    final RenderParagraph paragraph = tester.renderObject(
      find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('﴿٣﴾'),
      ),
    );
    final text = paragraph.text.toPlainText();
    final index = text.indexOf('﴿٣﴾');
    final boxes = paragraph.getBoxesForSelection(
      TextSelection(baseOffset: index, extentOffset: index + 3),
    );
    final boxCenter = paragraph.localToGlobal(boxes.first.toRect().center);
    await tester.tapAt(boxCenter);
    await tester.pump();
    expect(tappedAyah, 3);
  });
}

