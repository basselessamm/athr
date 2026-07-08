import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/favorites/providers/favorites_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return AthrScaffold(
      title: 'المفضلة',
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'لم تحفظ أي عنصر بعد. أثناء القراءة اضغط على القلب للاحتفاظ بالآيات والأحاديث والأدعية المهمة لك.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.7),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = favorites[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _openFavorite(context, item),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await ref
                                    .read(appDatabaseProvider)
                                    .toggleFavorite(
                                      contentType: item.contentType,
                                      primaryReference: item.primaryReference,
                                      secondaryReference:
                                          item.secondaryReference,
                                      title: item.title,
                                      contentText: item.contentText,
                                      source: item.source,
                                    );
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.contentText,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(height: 1.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.source,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('تعذر تحميل المفضلة: $error')),
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 4),
    );
  }

  void _openFavorite(BuildContext context, UserFavorite item) {
    switch (item.contentType) {
      case 'verse':
        final parts = item.primaryReference.split(':');
        final surah = int.tryParse(parts.first);
        if (surah != null) {
          context.push('/quran/$surah');
        }
        break;
      case 'hadith':
        final bookName = item.secondaryReference;
        if (bookName != null && bookName.isNotEmpty) {
          context.pushNamed('hadithReading', pathParameters: {'bookName': bookName});
        }
        break;
      case 'dua':
        final category = item.secondaryReference;
        if (category != null && category.isNotEmpty) {
          context.pushNamed('azkarReading', pathParameters: {'category': category});
        }
        break;
    }
  }
}
