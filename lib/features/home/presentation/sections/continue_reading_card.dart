import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_flutter/quran.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/widgets/athr_glass_card.dart';
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
          return const SizedBox.shrink();
        }

        final surahId = session.surahId!;
        final pageNum =
            session.pageNumber ??
            Quran.getPageNumber(surahNumber: surahId, verseNumber: 1);
        final juzNum = Quran.getJuzNumber(
          surahNumber: surahId,
          verseNumber: 1,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: _AnimatedTapCard(
            onTap: () {
              context.push('/quran/$surahId?page=$pageNum');
            },
            child: AthrGlassCard(
              blur: 18,
              opacity: 0.10,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_stories_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'متابعة القراءة',
                              style: AppTypography.cairoTextTheme().labelMedium
                                  ?.copyWith(
                                    color: theme.colorScheme.primary,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
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
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: theme.colorScheme.primary,
                      size: 26,
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

/// Wraps a child in a scale animation on tap for premium micro-interactions.
class _AnimatedTapCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedTapCard({required this.child, required this.onTap});

  @override
  State<_AnimatedTapCard> createState() => _AnimatedTapCardState();
}

class _AnimatedTapCardState extends State<_AnimatedTapCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
