import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midrar/features/quran/application/quran_audio.dart';
import 'package:midrar/features/quran/presentation/widgets/quran_audio_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Quran 31 Reciters Complete Verification', () {
    test('all 31 reciters have complete, non-empty, unique configurations', () {
      expect(quranReciters.length, 31);
      final ids = <String>{};
      final displayNames = <String>{};

      for (final reciter in quranReciters) {
        expect(reciter.id, isNotEmpty);
        expect(reciter.id.startsWith('ar.'), isTrue);
        expect(reciter.name, isNotEmpty);
        expect(reciter.displayName, isNotEmpty);
        expect(reciter.cdnBitrate, greaterThan(0));

        // Ensure no duplicate IDs
        expect(ids.add(reciter.id), isTrue, reason: 'Duplicate id: ${reciter.id}');

        // Ensure display names are unique
        expect(displayNames.add(reciter.displayName), isTrue,
            reason: 'Duplicate displayName: ${reciter.displayName}');
      }
    });

    test('verifies accurate URL generation across boundary ayahs for all 31 reciters', () {
      final repository = QuranAudioRepository();

      for (final reciter in quranReciters) {
        // 1. Ayah 1 (Al-Fatihah 1:1)
        final uri1 = repository.ayahStream(reciter: reciter, globalAyah: 1);
        expect(uri1.isScheme('https'), isTrue);
        if (reciter.provider == ReciterProvider.everyAyah) {
          expect(uri1.host, 'everyayah.com');
          expect(uri1.path.endsWith('001001.mp3'), isTrue,
              reason: 'Ayah 1 failed for ${reciter.name}: $uri1');
        } else {
          expect(uri1.host, 'cdn.islamic.network');
          expect(uri1.path.endsWith('/1.mp3'), isTrue,
              reason: 'Ayah 1 failed for ${reciter.name}: $uri1');
        }

        // 2. Ayah 8 (Al-Baqarah 2:1)
        final uri8 = repository.ayahStream(reciter: reciter, globalAyah: 8);
        if (reciter.provider == ReciterProvider.everyAyah) {
          expect(uri8.path.endsWith('002001.mp3'), isTrue,
              reason: 'Ayah 8 (Surah 2:1) failed for ${reciter.name}: $uri8');
        } else {
          expect(uri8.path.endsWith('/8.mp3'), isTrue,
              reason: 'Ayah 8 failed for ${reciter.name}: $uri8');
        }

        // 3. Ayah 6236 (An-Nas 114:6)
        final uriLast = repository.ayahStream(reciter: reciter, globalAyah: 6236);
        if (reciter.provider == ReciterProvider.everyAyah) {
          expect(uriLast.path.endsWith('114006.mp3'), isTrue,
              reason: 'Ayah 6236 (Surah 114:6) failed for ${reciter.name}: $uriLast');
        } else {
          expect(uriLast.path.endsWith('/6236.mp3'), isTrue,
              reason: 'Ayah 6236 failed for ${reciter.name}: $uriLast');
        }
      }
    });

    testWidgets('showReciterPicker displays all 31 reciters and allows selection',
        (tester) async {
      QuranReciter? chosen;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      chosen = await showReciterPicker(
                        context,
                        quranReciters.first,
                      );
                    },
                    child: const Text('Open Reciter Picker'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Tap to open sheet
      await tester.tap(find.text('Open Reciter Picker'));
      await tester.pumpAndSettle();

      // Verify title is rendered
      expect(find.text('اختر القارئ'), findsOneWidget);

      // Verify the first reciter is present
      expect(find.text('مشاري راشد العفاسي'), findsOneWidget);

      // Scroll down to find newly added reciters like Yasser Ad-Dussary and Saad Al-Ghamadi
      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      // Scroll until Yasser Ad-Dussary is visible
      await tester.scrollUntilVisible(
        find.text('ياسر الدوسري'),
        200.0,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();
      expect(find.text('ياسر الدوسري'), findsOneWidget);

      // Tap Yasser Ad-Dussary
      await tester.tap(find.text('ياسر الدوسري'));
      await tester.pumpAndSettle();

      // Verify chosen reciter
      expect(chosen?.id, 'ar.yasseraddussary');
      expect(chosen?.name, 'ياسر الدوسري');
    });
  });
}
