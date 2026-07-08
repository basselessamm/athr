import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/features/favorites/providers/favorites_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedItemsPreview extends ConsumerWidget {
  const SavedItemsPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'العناصر المحفوظة',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    context.push('/favorites');
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          favoritesAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: Text('لا توجد عناصر محفوظة حتى الآن')),
                );
              }

              // Show only top 3
              final previewItems = items.take(3).toList();

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: previewItems.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = previewItems[index];
                  return ListTile(
                    leading: _getIconForType(item.contentType, context),
                    title: Text(item.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTypeName(item.contentType),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (item.note != null && item.note!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.note,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.note!,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    isThreeLine: item.note != null && item.note!.isNotEmpty,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      // Basic routing based on type
                      if (item.contentType == 'verse') {
                        final parts = item.primaryReference.split(':');
                        if (parts.isNotEmpty) {
                          context.push('/quran/${parts.first}');
                        }
                      } else if (item.contentType == 'hadith') {
                        context.pushNamed(
                          'hadithReading',
                          pathParameters: {'bookName': item.primaryReference},
                        );
                      } else if (item.contentType == 'dua') {
                        context.pushNamed(
                          'azkarReading',
                          pathParameters: {'category': item.primaryReference},
                        );
                      }
                    },
                  );
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: Text('حدث خطأ أثناء تحميل المحفوظات')),
            ),
          ),
        ],
      ),
    );
  }

  Icon _getIconForType(String type, BuildContext context) {
    switch (type) {
      case 'verse':
        return Icon(
          Icons.menu_book,
          color: Theme.of(context).colorScheme.primary,
        );
      case 'hadith':
        return Icon(
          Icons.chrome_reader_mode,
          color: Theme.of(context).colorScheme.secondary,
        );
      case 'dua':
        return Icon(
          Icons.favorite,
          color: Theme.of(context).colorScheme.tertiary,
        );
      default:
        return Icon(
          Icons.bookmark,
          color: Theme.of(context).colorScheme.primary,
        );
    }
  }

  String _getTypeName(String type) {
    switch (type) {
      case 'verse':
        return 'آية';
      case 'hadith':
        return 'حديث';
      case 'dua':
        return 'دعاء/ذكر';
      default:
        return 'عنصر';
    }
  }
}
