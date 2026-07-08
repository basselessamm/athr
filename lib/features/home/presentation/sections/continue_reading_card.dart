import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_flutter/quran.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/features/reading_session/data/reading_session_repository.dart';

final lastQuranSessionProvider = StreamProvider((ref) {
  final repo = ref.watch(readingSessionRepositoryProvider);
  return repo.watchLastSession('quran');
});

class ContinueReadingCard extends ConsumerWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sessionAsync = ref.watch(lastQuranSessionProvider);

    return sessionAsync.when(
      data: (session) {
        if (session == null || session.surahId == null) {
          return const SizedBox.shrink(); // Hide if no reading history
        }

        final surahId = session.surahId!;
        final pageNum =
            session.pageNumber ??
            Quran.getPageNumber(surahNumber: surahId, verseNumber: 1);
        final juzNum = Quran.getJuzNumber(
          surahNumber: surahId,
          verseNumber: 1,
        ); // rough approximation

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: InkWell(
            onTap: () {
              context.push('/quran/$surahId?page=$pageNum');
            },
            borderRadius: AppRadius.card,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: AppRadius.card,
                boxShadow: AppShadows.minimal,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'متابعة القراءة',
                          style: AppTypography.cairoTextTheme().labelMedium
                              ?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                letterSpacing: 1.2,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'سورة ${Quran.getSurahName(surahId)}',
                          style: AppTypography.readingAmiriBold(
                            fontSize: 28,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'الجزء $juzNum • صفحة $pageNum',
                          style: AppTypography.cairoTextTheme().bodyMedium
                              ?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
