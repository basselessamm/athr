import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/favorites/providers/favorites_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favoritesAsync = ref.watch(favoritesProvider);

    return AthrScaffold(
      title: 'المفضلة',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: favoritesAsync.when(
          data: (favorites) {
            if (favorites.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_outline_rounded,
                        size: 64,
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'لا توجد عناصر محفوظة',
                        style: AppTypography.cairoTextTheme().titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'لم تحفظ أي عنصر بعد. أثناء القراءة اضغط على القلب للاحتفاظ بالآيات والأحاديث والأدعية المهمة لك.',
                        style: AppTypography.cairoTextTheme().bodyMedium
                            ?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.8,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                96,
              ),
              itemCount: favorites.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final item = favorites[index];
                return _FavoriteCard(item: item);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('تعذر تحميل المفضلة: $error')),
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 4),
    );
  }
}

class _FavoriteCard extends ConsumerWidget {
  final UserFavorite item;

  const _FavoriteCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Determine visual style based on content type
    IconData typeIcon;
    Color typeColor;

    switch (item.contentType) {
      case 'quran':
      case 'verse':
        typeIcon = Icons.menu_book_rounded;
        typeColor = const Color(0xFFD97736); // Warm Orange
        break;
      case 'hadith':
        typeIcon = Icons.format_quote_rounded;
        typeColor = const Color(0xFF3E6B5B); // Earthy Green
        break;
      case 'azkar':
      case 'dua':
        typeIcon = Icons.volunteer_activism_rounded;
        typeColor = const Color(0xFF6B3E6A); // Deep Purple
        break;
      default:
        typeIcon = Icons.bookmark_rounded;
        typeColor = theme.colorScheme.primary;
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => _openFavorite(context, item),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(typeIcon, color: typeColor, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          item.title,
                          style: AppTypography.cairoTextTheme().titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(appDatabaseProvider)
                            .toggleFavorite(
                              contentType: item.contentType,
                              primaryReference: item.primaryReference,
                              secondaryReference: item.secondaryReference,
                              title: item.title,
                              contentText: item.contentText,
                              source: item.source,
                            );
                      },
                      icon: Icon(
                        Icons.favorite_rounded,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  item.contentText,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                    height: 1.8,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (item.note != null && item.note!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: theme.colorScheme.tertiaryContainer,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.edit_note_rounded,
                          color: theme.colorScheme.onTertiaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            item.note!,
                            style: AppTypography.cairoTextTheme().bodySmall
                                ?.copyWith(
                                  color: theme.colorScheme.onTertiaryContainer,
                                  height: 1.6,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.round),
                      ),
                      child: Text(
                        item.source,
                        style: AppTypography.cairoTextTheme().labelSmall
                            ?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _editNote(context, ref, item),
                      icon: const Icon(Icons.add_comment_rounded, size: 16),
                      label: Text(
                        item.note != null && item.note!.isNotEmpty
                            ? 'تعديل الملاحظة'
                            : 'إضافة ملاحظة',
                        style: AppTypography.cairoTextTheme().labelMedium,
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openFavorite(BuildContext context, UserFavorite item) {
    switch (item.contentType) {
      case 'quran':
      case 'verse':
        final parts = item.primaryReference.split(':');
        final surah = int.tryParse(parts.first);
        final ayah = parts.length > 1 ? int.tryParse(parts[1]) : null;
        if (surah != null) {
          final ayahQuery = ayah != null ? '?ayah=$ayah' : '';
          context.push('/quran/$surah$ayahQuery');
        }
        break;
      case 'hadith':
        final bookName = item.secondaryReference;
        if (bookName != null && bookName.isNotEmpty) {
          context.pushNamed(
            'hadithReading',
            pathParameters: {'bookName': bookName},
          );
        }
        break;
      case 'azkar':
      case 'dua':
        final category = item.secondaryReference ?? item.source;
        if (category.isNotEmpty) {
          context.pushNamed(
            'azkarReading',
            pathParameters: {'category': category},
          );
        }
        break;
      default:
        break;
    }
  }

  Future<void> _editNote(
    BuildContext context,
    WidgetRef ref,
    UserFavorite item,
  ) async {
    final controller = TextEditingController(text: item.note);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ملاحظة',
          style: AppTypography.cairoTextTheme().titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          style: AppTypography.cairoTextTheme().bodyMedium,
          decoration: InputDecoration(
            hintText: 'اكتب ملاحظتك هنا...',
            hintStyle: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
            ),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (result != null) {
      final db = ref.read(appDatabaseProvider);
      await (db.update(db.userFavoriteTable)
            ..where((t) => t.id.equals(item.id)))
          .write(UserFavoriteTableCompanion(note: drift.Value(result)));
    }
  }
}
