import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/features/library/modules/notes/providers/notes_providers.dart';
import 'package:athr/core/widgets/loading/list_tile_skeleton.dart';
import 'package:athr/core/widgets/empty_state_card.dart';
import 'package:athr/core/database/app_database.dart';

class NotesSection extends ConsumerWidget {
  final void Function(UserNote note) onNotePressed;
  final VoidCallback onCreatePressed;

  const NotesSection({
    super.key,
    required this.onNotePressed,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return notesAsync.when(
      data: (notes) {
        if (notes.isEmpty) {
          return EmptyStateCard(
            icon: Icons.note_alt_outlined,
            title: 'لا توجد ملاحظات',
            description: 'دوّن تأملاتك وخواطرك الإيمانية هنا.',
            actionLabel: 'إضافة ملاحظة',
            onAction: onCreatePressed,
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                'آخر تعديل: ${note.updatedAt.toString().substring(0, 10)}',
              ),
              onTap: () => onNotePressed(note),
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
