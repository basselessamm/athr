import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/widgets/athr_glass_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      (
        title: 'أدعية المواقف',
        subtitle: 'دعاء حاضر للمواقف اليومية القريبة منك.',
        icon: Icons.chat_bubble_outline_rounded,
        color: const Color(0xFF5B7B6F),
        route: '/situations',
      ),
      (
        title: 'المحاسبة اليومية',
        subtitle: 'راجع يومك سريعاً وحدد أثر الطاعات.',
        icon: Icons.assignment_turned_in_rounded,
        color: const Color(0xFF7A6242),
        route: '/muhasaba',
      ),
      (
        title: 'المفضلة',
        subtitle: 'ارجع لما حفظته ليكون قريباً عند الحاجة.',
        icon: Icons.favorite_rounded,
        color: const Color(0xFF5A4328),
        route: '/favorites',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وصول سريع',
                      style: AppTypography.cairoTextTheme().titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'مسارات مختصرة لصفحات تستخدمها كثيراً أثناء يومك.',
                      style: AppTypography.cairoTextTheme().bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.65,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                child: Text(
                  '${actions.length} أدوات',
                  style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 420;
              final spacing = AppSpacing.md;
              final columns = isCompact ? 1 : 2;
              final itemWidth = columns == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - spacing) / 2;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: actions.map((action) {
                  return SizedBox(
                    width: itemWidth,
                    child: _QuickActionCard(
                      title: action.title,
                      subtitle: action.subtitle,
                      icon: action.icon,
                      color: action.color,
                      onTap: () => context.push(action.route),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AthrGlassCard(
          blur: 16,
          opacity: 0.08,
          padding: const EdgeInsets.all(AppSpacing.md),
          border: Border.all(
            color: widget.color.withValues(alpha: 0.18),
            width: 1.2,
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 148),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.18),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 26),
                ),
                const SizedBox(height: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      widget.subtitle,
                      style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(
                      'افتح الآن',
                      style: AppTypography.cairoTextTheme().labelLarge?.copyWith(
                        color: widget.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(Icons.arrow_back_rounded, size: 18, color: widget.color),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
