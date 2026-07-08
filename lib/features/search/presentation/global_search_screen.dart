import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/search/providers/search_provider.dart';
import 'package:athr/features/search/domain/entities/search_result_entity.dart';

class GlobalSearchScreen extends ConsumerWidget {
  const GlobalSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchResultsProvider);
    final theme = Theme.of(context);
    final query = ref.watch(searchQueryProvider);

    return AthrScaffold(
      title: 'البحث الشامل',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.card,
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
                child: TextField(
                  autofocus: true,
                  style: AppTypography.cairoTextTheme().bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'ابحث في القرآن، الأحاديث، الأذكار...',
                    hintStyle: AppTypography.cairoTextTheme().bodyLarge
                        ?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              ref.read(searchQueryProvider.notifier).state = '';
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  onChanged: (val) {
                    ref.read(searchQueryProvider.notifier).state = val;
                  },
                ),
              ),
            ),
            Expanded(
              child: searchResults.when(
                data: (results) {
                  if (query.isEmpty) {
                    return _EmptyState(
                      icon: Icons.search_rounded,
                      message: 'اكتب شيئاً للبحث في مكتبة أثر',
                    );
                  }
                  if (results.isEmpty) {
                    return _EmptyState(
                      icon: Icons.search_off_rounded,
                      message: 'لا توجد نتائج مطابقة لبحثك',
                    );
                  }
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: results.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.lg),
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return _SearchResultCard(result: result);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    'حدث خطأ أثناء البحث\n$err',
                    style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final SearchResultEntity result;

  const _SearchResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData typeIcon;
    Color typeColor;
    String typeLabel;

    switch (result.featureType) {
      case 'quran':
        typeIcon = Icons.menu_book_rounded;
        typeColor = const Color(0xFFD97736); // Warm Orange
        typeLabel = 'قرآن';
        break;
      case 'hadith':
        typeIcon = Icons.format_quote_rounded;
        typeColor = const Color(0xFF3E6B5B); // Earthy Green
        typeLabel = 'حديث';
        break;
      case 'azkar':
        typeIcon = Icons.volunteer_activism_rounded;
        typeColor = const Color(0xFF6B3E6A); // Deep Purple
        typeLabel = 'أذكار';
        break;
      default:
        typeIcon = Icons.search_rounded;
        typeColor = theme.colorScheme.primary;
        typeLabel = 'نتيجة';
    }

    return Ink(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: AppShadows.minimal,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          if (result.featureType == 'quran') {
            context.push('/quran/${result.referenceId}');
          } else if (result.featureType == 'hadith') {
            final bookName = result.title?.split(' - ').first ?? 'صحيح البخاري';
            context.pushNamed(
              'hadithReading',
              pathParameters: {'bookName': bookName},
            );
          } else if (result.featureType == 'azkar') {
            final category = result.title ?? '';
            context.pushNamed(
              'azkarReading',
              pathParameters: {'category': category},
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(typeIcon, size: 14, color: typeColor),
                        const SizedBox(width: 4),
                        Text(
                          typeLabel,
                          style: AppTypography.cairoTextTheme().labelSmall
                              ?.copyWith(
                                color: typeColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      result.title ?? typeLabel,
                      style: AppTypography.cairoTextTheme().titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                result.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.amiri(
                  height: 1.8,
                  fontSize: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
