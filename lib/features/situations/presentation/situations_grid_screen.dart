import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:midrar/core/theme/app_colors.dart';
import 'package:midrar/core/widgets/midrar_scaffold.dart';
import 'package:midrar/features/situations/providers/situations_providers.dart';

class SituationsGridScreen extends ConsumerWidget {
  const SituationsGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final situations = ref.watch(situationsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MidrarScaffold(
        title: 'مواقف وتأملات',
        body: GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14.0,
            mainAxisSpacing: 14.0,
            childAspectRatio: 0.86,
          ),
          itemCount: situations.length,
          itemBuilder: (context, index) {
            final situation = situations[index];
            return _SituationCard(situation: situation);
          },
        ),
      ),
    );
  }
}

class _SituationCard extends StatelessWidget {
  final Situation situation;

  const _SituationCard({required this.situation});

  (IconData, Color) _getVisual(String id) {
    switch (id) {
      case '1': // الهم والحزن
        return (Icons.healing_outlined, AppColors.emotionComfort);
      case '2': // الكرب والضيق
        return (Icons.wb_twilight_outlined, AppColors.emotionTranquility);
      case '3': // تعسر الأمور
        return (Icons.explore_outlined, AppColors.emotionHope);
      case '4': // القلق والفزع
        return (Icons.shield_outlined, AppColors.emotionTranquility);
      case '5': // الوقوع في ذنب
        return (Icons.autorenew_rounded, AppColors.emotionReflection);
      case '6': // الشك في الإيمان
        return (Icons.verified_outlined, AppColors.emotionHope);
      case '7': // قضاء الدين
        return (Icons.account_balance_wallet_outlined, AppColors.emotionGratitude);
      case '8': // الغضب
        return (Icons.water_drop_outlined, AppColors.emotionTranquility);
      default:
        return (Icons.spa_outlined, AppColors.lightAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final (icon, accentColor) = _getVisual(situation.id);

    return InkWell(
      onTap: () {
        context.push('/situations/${situation.id}');
      },
      borderRadius: BorderRadius.circular(AppColors.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.25)
                  : const Color(0xFF1C443B).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.18 : 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
                  width: 1.2,
                ),
              ),
              child: Icon(
                icon,
                color: isDark ? accentColor.withValues(alpha: 0.9) : accentColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              situation.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                situation.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                  fontSize: 11.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
