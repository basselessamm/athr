import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/azkar/providers/azkar_providers.dart';

class AzkarCategoriesScreen extends ConsumerWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(azkarCategoriesProvider);

    return AthrScaffold(
      title: 'الأذكار',
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF8C6D2D).withValues(alpha: 0.1),
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
                      'حصن المسلم',
                      style: AppTypography.cairoTextTheme().titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'أذكار الصباح والمساء وكل ما يحتاجه المسلم في يومه وليله.',
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
            categoriesAsync.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('لا توجد تصنيفات للأذكار بعد.')),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: 120,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _AzkarCategoryCard(category: category),
                      );
                    }, childCount: categories.length),
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
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 2),
    );
  }
}

class _AzkarCategoryCard extends StatelessWidget {
  final String category;

  const _AzkarCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine icon and colors based on category name
    IconData icon = Icons.shield_rounded;
    Color accentColor = const Color(0xFF8C6D2D); // Default gold
    String subtitle = 'حصن يومي ومناجاة';

    if (category.contains('صباح')) {
      icon = Icons.wb_sunny_rounded;
      accentColor = const Color(0xFFD4A373); // Morning orange/gold
      subtitle = 'لبداية يوم مبارك في حفظ الله';
    } else if (category.contains('مساء')) {
      icon = Icons.nights_stay_rounded;
      accentColor = const Color(0xFF4A4E69); // Evening dark purple/blue
      subtitle = 'ختام يومك بسكينة وطمأنينة';
    } else if (category.contains('نوم')) {
      icon = Icons.bedtime_rounded;
      accentColor = const Color(0xFF22223B); // Deep night
      subtitle = 'لراحة البال وحفظ النفس أثناء النوم';
    } else if (category.contains('صلاة')) {
      icon = Icons.mosque_rounded;
      accentColor = const Color(0xFF3E6B5B); // Green
      subtitle = 'أذكار ما بعد الصلوات المكتوبة';
    } else if (category.contains('استيقاظ')) {
      icon = Icons.wb_twilight_rounded;
      accentColor = const Color(0xFFE07A5F);
      subtitle = 'شكر لله على نعمة الحياة بعد الممات';
    }

    return InkWell(
      onTap: () => context.pushNamed(
        'azkarReading',
        pathParameters: {'category': category},
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
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
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
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
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
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: theme.colorScheme.outlineVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
