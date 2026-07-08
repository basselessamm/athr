import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/situations/providers/situations_providers.dart';

class SituationsGridScreen extends ConsumerWidget {
  const SituationsGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final situations = ref.watch(situationsProvider);

    return AthrScaffold(
      title: 'مواقف الحياة',
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
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.85,
          ),
          itemCount: situations.length,
          itemBuilder: (context, index) {
            final situation = situations[index];
            return _SituationCard(situation: situation, index: index);
          },
        ),
      ),
    );
  }
}

class _SituationCard extends StatelessWidget {
  final Situation situation;
  final int index;

  const _SituationCard({required this.situation, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Subtle alternating colors for the cards to make the grid pop
    final colorAccent = index % 3 == 0
        ? const Color(0xFFD97736) // Warm Orange
        : index % 3 == 1
        ? const Color(0xFF3E6B5B) // Earthy Green
        : const Color(0xFF6B3E6A); // Deep Purple

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
          onTap: () {
            context.push('/situations/${situation.id}');
          },
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorAccent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    situation.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  situation.title,
                  style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    situation.description,
                    style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
