import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_flutter/quran.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/features/favorites/providers/favorites_providers.dart';
import 'package:athr/features/quran/providers/quran_providers.dart';

class VerseBottomSheet extends ConsumerWidget {
  final int surahNumber;
  final int ayahNumber;

  const VerseBottomSheet({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafseerAsync = ref.watch(
      tafseerProvider((surah: surahNumber, ayah: ayahNumber)),
    );
    final verseText = Quran.getVerse(
      surahNumber: surahNumber,
      verseNumber: ayahNumber,
    ).text;
    final reference = '$surahNumber:$ayahNumber';
    final favoriteAsync = ref.watch(
      isFavoriteProvider((type: 'verse', reference: reference)),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الآية $ayahNumber',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: verseText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم نسخ الآية')),
                          );
                        },
                        tooltip: 'نسخ الآية',
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(appDatabaseProvider)
                              .toggleFavorite(
                                contentType: 'verse',
                                primaryReference: reference,
                                title:
                                    'سورة ${Quran.getSurahName(surahNumber)} - الآية $ayahNumber',
                                contentText: verseText,
                                source: 'القرآن الكريم',
                              );
                        },
                        icon: favoriteAsync.when(
                          data: (isFavorite) => Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? Theme.of(context).colorScheme.error
                                : null,
                          ),
                          loading: () => const Icon(Icons.favorite_border),
                          error: (error, stackTrace) =>
                              const Icon(Icons.favorite_border),
                        ),
                        tooltip: 'حفظ في المفضلة',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                verseText,
                style: GoogleFonts.amiri(fontSize: 24, height: 1.8),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              const Text(
                'التفسير الميسر',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Tafseer takes the remaining space
              Expanded(
                child: tafseerAsync.when(
                  data: (tafseer) => SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      tafseer,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) =>
                      Center(child: Text('خطأ في تحميل التفسير: $e')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
