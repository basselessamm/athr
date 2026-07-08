import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/features/library/domain/entities/saved_item_type.dart';
import 'package:athr/features/library/providers/saved_items_providers.dart';
import 'package:athr/core/widgets/loading/list_tile_skeleton.dart';
import 'package:athr/core/widgets/empty_state_card.dart';
import 'package:athr/core/database/app_database.dart';

class SavedHadithSection extends ConsumerWidget {
  final void Function(SavedItem item) onItemPressed;
  final VoidCallback onBrowsePressed;

  const SavedHadithSection({
    super.key,
    required this.onItemPressed,
    required this.onBrowsePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedHadithAsync = ref.watch(
      savedItemsProvider(SavedItemType.hadith),
    );

    return savedHadithAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return EmptyStateCard(
            icon: Icons.bookmark_border,
            title: 'لا توجد أحاديث محفوظة',
            description: 'احفظ الأحاديث النبوية للرجوع إليها بسهولة.',
            actionLabel: 'تصفح الأحاديث',
            onAction: onBrowsePressed,
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(
                item.previewText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('رقم الحديث: ${item.referenceId}'),
              onTap: () => onItemPressed(item),
            );
          },
        );
      },
      loading: () => const ListTileSkeleton(itemCount: 2),
      error: (e, st) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('حدث خطأ: $e'),
        ),
      ),
    );
  }
}
