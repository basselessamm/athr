import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/database/database_providers.dart';
import 'package:athr/core/widgets/athr_card.dart';
import 'package:athr/features/favorites/providers/favorites_providers.dart';
import 'package:athr/features/home/providers/home_providers.dart';

class DailyDuaCard extends ConsumerWidget {
  const DailyDuaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duaAsync = ref.watch(dailyDuaProvider);

    return AthrCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'دعاء اليوم',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          duaAsync.when(
            data: (dua) {
              if (dua == null) {
                return const Text('لا توجد أدعية متاحة الآن.');
              }

              final favoriteAsync = ref.watch(
                isFavoriteProvider((type: 'dua', reference: dua.id.toString())),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    dua.duaText,
                    style: const TextStyle(fontSize: 18, height: 1.8),
                    textAlign: TextAlign.center,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 8,
                    spacing: 8,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dua.category,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          if (dua.reference != null &&
                              dua.reference!.isNotEmpty)
                            Text(
                              dua.reference!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => context.push(
                              '/azkar/${Uri.encodeComponent(dua.category)}',
                            ),
                            child: const Text('فتح التصنيف'),
                          ),
                          IconButton(
                            onPressed: () async {
                              await ref
                                  .read(appDatabaseProvider)
                                  .toggleFavorite(
                                    contentType: 'dua',
                                    primaryReference: dua.id.toString(),
                                    secondaryReference: dua.category,
                                    title: dua.category,
                                    contentText: dua.duaText,
                                    source: dua.reference ?? 'حصن المسلم',
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
            error: (e, stackTrace) => Text('تعذر تحميل دعاء اليوم: $e'),
          ),
        ],
      ),
    );
  }
}
