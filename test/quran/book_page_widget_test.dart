import 'package:midrar/features/quran/presentation/widgets/book_page_widget.dart';
import 'package:flutter/material.dart';
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

    final marker = find.byKey(const ValueKey('ayah-marker-1-1'));
    expect(marker, findsOneWidget);

    await tester.tap(marker);
    await tester.pump();

    expect(selectedSurah, 1);
    expect(selectedAyah, 1);
  });
}
