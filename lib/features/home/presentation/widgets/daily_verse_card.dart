import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:athr/core/database/database_providers.dart';
import 'package:athr/core/widgets/athr_card.dart';
import 'package:athr/features/favorites/providers/favorites_providers.dart';
import 'package:athr/features/home/providers/home_providers.dart';

class DailyVerseCard extends ConsumerWidget {
  const DailyVerseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verse = ref.watch(dailyVerseProvider);
    final favoriteAsync = ref.watch(
      isFavoriteProvider((
        type: 'verse',
        reference: '${verse.surah}:${verse.ayah}',
      )),
    );

    return AthrCard(
      onTap: () => context.push('/quran/${verse.surah}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'آية اليوم',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await ref
                      .read(appDatabaseProvider)
                      .toggleFavorite(
                        contentType: 'verse',
                        primaryReference: '${verse.surah}:${verse.ayah}',
                        title: 'سورة ${verse.surahName} - الآية ${verse.ayah}',
                        contentText: verse.text,
                        source: verse.source,
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
          const SizedBox(height: 12),
          Text(
            verse.text,
            style: GoogleFonts.amiri(fontSize: 22, height: 1.9),
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            'سورة ${verse.surahName} - الآية ${verse.ayah}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            verse.source,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
