import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/features/library/domain/entities/saved_item_type.dart';
import 'package:athr/features/library/providers/saved_items_providers.dart';
import 'package:athr/core/widgets/loading/list_tile_skeleton.dart';
import 'package:athr/core/widgets/empty_state_card.dart';
import 'package:athr/core/database/app_database.dart';

class SavedQuranSection extends ConsumerWidget {
  final void Function(SavedItem item) onItemPressed;
  final VoidCallback onBrowsePressed;

  const SavedQuranSection({
    super.key,
    required this.onItemPressed,
    required this.onBrowsePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedQuranAsync = ref.watch(savedItemsProvider(SavedItemType.quran));

    return savedQuranAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return EmptyStateCard(
            icon: Icons.menu_book,
            title: 'لا توجد آيات محفوظة',
            description: 'احفظ الآيات التي تلامس قلبك للرجوع إليها لاحقاً.',
            actionLabel: 'تصفح القرآن',
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
              title: Text(item.previewText),
              subtitle: Text(
                'سورة ${item.referenceId} - آية ${item.secondaryId ?? ""}',
              ),
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
