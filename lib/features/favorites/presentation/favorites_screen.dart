import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/core/memory/memory_providers.dart';
import 'package:midrar/core/theme/app_colors.dart';
import 'package:midrar/core/widgets/main_navigation_bar.dart';
import 'package:midrar/core/widgets/midrar_scaffold.dart';
import 'package:midrar/features/favorites/providers/favorites_providers.dart';
import 'package:midrar/features/memory_return/application/memory_return_service.dart';

enum _AthrFilter { activeThreads, archivedThreads, quickFavorites }

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  _AthrFilter _currentFilter = _AthrFilter.activeThreads;

  @override
  Widget build(BuildContext context) {
    final allThreadsAsync = ref.watch(allMemoryThreadsProvider);
    final legacyFavoritesAsync = ref.watch(favoritesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MidrarScaffold(
        title: 'المحفوظات · خيوط العودة',
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      selected: _currentFilter == _AthrFilter.activeThreads,
                      label: const Text('خيوط العودة النشطة'),
                      avatar: const Icon(Icons.route_outlined, size: 16),
                      onSelected: (_) => setState(() => _currentFilter = _AthrFilter.activeThreads),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _currentFilter == _AthrFilter.archivedThreads,
                      label: const Text('المؤرشفة'),
                      avatar: const Icon(Icons.archive_outlined, size: 16),
                      onSelected: (_) => setState(() => _currentFilter = _AthrFilter.archivedThreads),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _currentFilter == _AthrFilter.quickFavorites,
                      label: const Text('المحفوظات السابقة'),
                      avatar: const Icon(Icons.bookmark_outline, size: 16),
                      onSelected: (_) => setState(() => _currentFilter = _AthrFilter.quickFavorites),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _buildContent(
                context,
                allThreadsAsync,
                legacyFavoritesAsync,
                theme,
                isDark,
              ),
            ),
          ],
        ),
        bottomNavigationBar: const MainNavigationBar(selectedIndex: 4),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AsyncValue<List<MemoryThread>> allThreadsAsync,
    AsyncValue<List<UserFavorite>> legacyFavoritesAsync,
    ThemeData theme,
    bool isDark,
  ) {
    if (_currentFilter == _AthrFilter.quickFavorites) {
      return legacyFavoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('تعذر تحميل المحفوظات: $error')),
        data: (favorites) {
          if (favorites.isEmpty) {
            return _buildEmptyState(
              context,
              title: 'لا توجد محفوظات سابقة',
              subtitle: 'يمكنك حفظ الآيات والأحاديث والأدعية للرجوع السريع إليها.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: favorites.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = favorites[index];
              return _buildLegacyFavoriteCard(context, item, theme, isDark);
            },
          );
        },
      );
    }

    return allThreadsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('تعذر تحميل خيوط العودة: $error')),
      data: (threads) {
        final filtered = _currentFilter == _AthrFilter.activeThreads
            ? threads.where((t) => t.status == ThreadStatus.active).toList()
            : threads.where((t) => t.status == ThreadStatus.archived).toList();

        if (filtered.isEmpty) {
          return _buildEmptyState(
            context,
            title: _currentFilter == _AthrFilter.activeThreads
                ? 'لا توجد خيوط نشطة بعد'
                : 'لا توجد خيوط مؤرشفة',
            subtitle: _currentFilter == _AthrFilter.activeThreads
                ? 'احفظ آية أو حديثًا أو ذكرًا لتدوين تأملك والعودة إليه لاحقًا.'
                : 'عند إتمام تدبر أي خيط يمكنك أرشفته ليبقى محفوظًا هنا في سكون.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          itemCount: filtered.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final thread = filtered[index];
            return _buildThreadCard(context, thread, theme, isDark);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
              ),
              child: Icon(
                Icons.spa_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.push('/quran'),
                  icon: const Icon(Icons.menu_book_rounded, size: 16),
                  label: const Text('المصحف'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.push('/hadith'),
                  icon: const Icon(Icons.import_contacts_rounded, size: 16),
                  label: const Text('الحديث'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.push('/azkar'),
                  icon: const Icon(Icons.spa_rounded, size: 16),
                  label: const Text('الأذكار'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreadCard(
    BuildContext context,
    MemoryThread thread,
    ThemeData theme,
    bool isDark,
  ) {
    final source = thread.source;
    final citation = [
      source.sourceBook,
      source.sourceCitation,
    ].whereType<String>().where((v) => v.isNotEmpty).join(' · ');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        onTap: () => context.push('/memory/${thread.id}'),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: isDark ? 0.4 : 0.6,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _iconForSource(source.kind),
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          source.sourceLabel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (citation.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            citation,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: thread.status == ThreadStatus.active ? 'أرشفة الخيط' : 'استعادة للنشطة',
                    onPressed: () async {
                      final repo = ref.read(memoryThreadRepositoryProvider);
                      if (thread.status == ThreadStatus.active) {
                        await repo.archiveThread(thread.id);
                      } else {
                        await repo.updateThread(
                          thread.copyWith(status: ThreadStatus.active, updatedAt: DateTime.now()),
                        );
                      }
                    },
                    icon: Icon(
                      thread.status == ThreadStatus.active
                          ? Icons.archive_outlined
                          : Icons.unarchive_outlined,
                      size: 20,
                    ),
                  ),
                ],
              ),
              if (thread.context != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      _contextLabel(thread.context!),
                      style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        ref.read(memoryReturnServiceProvider).returnToThread(
                          GoRouter.of(context),
                          thread,
                          kind: ReturnEventKind.opened,
                        );
                      },
                      icon: const Icon(Icons.keyboard_return_rounded, size: 16),
                      label: const Text('العودة للموضع'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => context.push('/memory/${thread.id}'),
                    child: const Text('التفاصيل'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegacyFavoriteCard(
    BuildContext context,
    UserFavorite item,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        onTap: () => _openLegacyFavorite(context, item),
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
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    tooltip: 'إزالة من المحفوظات',
                    onPressed: () async {
                      await ref.read(appDatabaseProvider).toggleFavorite(
                            contentType: item.contentType,
                            primaryReference: item.primaryReference,
                            secondaryReference: item.secondaryReference,
                            title: item.title,
                            contentText: item.contentText,
                            source: item.source,
                          );
                    },
                    icon: Icon(
                      Icons.bookmark_rounded,
                      color: theme.colorScheme.primary,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.source,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'فتح الموضع ←',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForSource(SourceKind kind) {
    switch (kind) {
      case SourceKind.quranVerse:
      case SourceKind.quranReading:
        return Icons.menu_book_rounded;
      case SourceKind.hadith:
        return Icons.import_contacts_rounded;
      case SourceKind.dua:
      case SourceKind.azkar:
        return Icons.spa_rounded;
      case SourceKind.situation:
        return Icons.wb_twilight_outlined;
    }
  }

  String _contextLabel(UserContext ctx) {
    switch (ctx.kind) {
      case UserContextKind.returnTo:
        return 'أعود إليه لاحقاً';
      case UserContextKind.continueLater:
        return 'متابعة القراءة';
      case UserContextKind.quietReading:
        return 'قراءة هادئة';
      case UserContextKind.applyLater:
        return 'للعمل والتطبيق';
      case UserContextKind.custom:
        return ctx.customLabel ?? 'خاطرة خاصة';
    }
  }

  void _openLegacyFavorite(BuildContext context, UserFavorite item) {
    switch (item.contentType) {
      case 'verse':
        final parts = item.primaryReference.split(':');
        final surah = int.tryParse(parts.first);
        final ayah = parts.length > 1 ? int.tryParse(parts[1]) : null;
        if (surah != null) {
          final query = ayah != null ? '?ayah=$ayah' : '';
          context.push('/quran/$surah$query');
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
