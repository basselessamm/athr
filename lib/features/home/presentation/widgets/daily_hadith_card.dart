import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/database/database_providers.dart';
import 'package:athr/core/widgets/athr_card.dart';
import 'package:athr/features/favorites/providers/favorites_providers.dart';
import 'package:athr/features/home/providers/home_providers.dart';

class DailyHadithCard extends ConsumerWidget {
  const DailyHadithCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hadithAsync = ref.watch(dailyHadithProvider);

    return AthrCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'حديث اليوم',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          hadithAsync.when(
            data: (hadith) {
              if (hadith == null) {
                return const Text('لا توجد أحاديث متاحة الآن.');
              }

              final favoriteAsync = ref.watch(
                isFavoriteProvider((
                  type: 'hadith',
                  reference: hadith.id.toString(),
                )),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    hadith.hadithTextAr,
                    style: const TextStyle(fontSize: 18, height: 1.8),
                    textAlign: TextAlign.justify,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 8,
                    spacing: 8,
                    children: [
                      Text(
                        hadith.reference ?? hadith.bookName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.pushNamed('hadithReading', pathParameters: {'bookName': hadith.bookName});
                            },
                            child: const Text('فتح الكتاب'),
                          ),
                          IconButton(
                            onPressed: () async {
                              await ref
                                  .read(appDatabaseProvider)
                                  .toggleFavorite(
                                    contentType: 'hadith',
                                    primaryReference: hadith.id.toString(),
                                    secondaryReference: hadith.bookName,
                                    title: hadith.reference ?? hadith.bookName,
                                    contentText: hadith.hadithTextAr,
                                    source: hadith.reference ?? hadith.bookName,
                                  );
                            },
                            icon: favoriteAsync.when(
                              data: (isFavorite) => Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                              ),
                              loading: () => const Icon(Icons.favorite_border),
                              error: (error, stackTrace) =>
                                  const Icon(Icons.favorite_border),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stackTrace) => Text('تعذر تحميل حديث اليوم: $e'),
          ),
        ],
      ),
    );
  }
}
