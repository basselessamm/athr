import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/hadith/providers/hadith_providers.dart';

class HadithBooksScreen extends ConsumerWidget {
  const HadithBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final booksAsync = ref.watch(hadithBooksProvider);

    return AthrScaffold(
      title: 'الأحاديث النبوية',
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF7A6242).withValues(alpha: 0.1),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.25, 1.0],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المصادر الصحاح',
                      style: AppTypography.cairoTextTheme().titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'اختر كتاباً لتبدأ بقراءة أحاديث النبي ﷺ والتفقه في الدين.',
                      style: AppTypography.cairoTextTheme().bodyMedium
                          ?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.6,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            booksAsync.when(
              data: (books) {
                if (books.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('لا توجد كتب أحاديث بعد.')),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: 120, // Bottom padding for nav bar
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.85,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final book = books[index];
                      String arabicName = book;
                      String subtitle = 'مصنف حديث';

                      if (book.toLowerCase().contains('bukhari')) {
                        arabicName = 'صحيح البخاري';
                        subtitle = 'أصح الكتب بعد القرآن الكريم';
                      }
                      if (book.toLowerCase().contains('muslim')) {
                        arabicName = 'صحيح مسلم';
                        subtitle = 'من أمهات كتب الحديث الصحاح';
                      }

                      return _HadithBookCard(
                        bookId: book,
                        arabicName: arabicName,
                        subtitle: subtitle,
                        index: index,
                      );
                    }, childCount: books.length),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) =>
                  SliverFillRemaining(child: Center(child: Text('خطأ: $e'))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 3),
    );
  }
}

class _HadithBookCard extends StatelessWidget {
  final String bookId;
  final String arabicName;
  final String subtitle;
  final int index;

  const _HadithBookCard({
    required this.bookId,
    required this.arabicName,
    required this.subtitle,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = const Color(0xFF7A6242);

    return InkWell(
      onTap: () => context.pushNamed(
        'hadithReading',
        pathParameters: {'bookName': bookId},
      ),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Ink(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: accentColor.withValues(alpha: 0.2)),
          boxShadow: AppShadows.minimal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      accentColor.withValues(alpha: 0.2),
                      accentColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Icon(
                    Icons.library_books_rounded,
                    color: accentColor,
                    size: 24,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arabicName,
                  style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
