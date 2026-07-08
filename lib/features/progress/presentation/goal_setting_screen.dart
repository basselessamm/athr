import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:drift/drift.dart' as drift;

class GoalSettingScreen extends ConsumerStatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  ConsumerState<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends ConsumerState<GoalSettingScreen> {
  String _selectedGoalType = 'minutes';
  int _targetValue = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AthrScaffold(
      title: 'تحديد الهدف',
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ما هو هدفك اليومي؟',
                style: AppTypography.cairoTextTheme().headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'اختر المقياس الذي تود الالتزام به يومياً وسنساعدك في تتبعه',
                style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              _GoalTypeSelector(
                title: 'دقائق القراءة',
                subtitle: 'خصص وقتاً ثابتاً يومياً للقرآن',
                icon: Icons.timer_rounded,
                isSelected: _selectedGoalType == 'minutes',
                onTap: () {
                  setState(() {
                    _selectedGoalType = 'minutes';
                    _targetValue = 30;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _GoalTypeSelector(
                title: 'عدد الصفحات',
                subtitle: 'حدد ورداً يومياً بعدد الصفحات',
                icon: Icons.menu_book_rounded,
                isSelected: _selectedGoalType == 'pages',
                onTap: () {
                  setState(() {
                    _selectedGoalType = 'pages';
                    _targetValue = 10;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _GoalTypeSelector(
                title: 'الأذكار المنجزة',
                subtitle: 'حافظ على أورادك اليومية',
                icon: Icons.shield_rounded,
                isSelected: _selectedGoalType == 'azkar',
                onTap: () {
                  setState(() {
                    _selectedGoalType = 'azkar';
                    _targetValue = 100;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'الكمية المستهدفة',
                style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildTargetAdjuster(theme),
              const SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: _saveGoal,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  elevation: 4,
                  shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
                ),
                child: Text(
                  'حفظ الهدف وتفعيله',
                  style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetAdjuster(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AdjustButton(
            icon: Icons.remove_rounded,
            onPressed: () {
              if (_targetValue > 1) {
                setState(() => _targetValue -= _getIncrement());
              }
            },
            theme: theme,
          ),
          Column(
            children: [
              Text(
                '$_targetValue',
                style: AppTypography.cairoTextTheme().displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                _getUnitLabel(),
                style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          _AdjustButton(
            icon: Icons.add_rounded,
            onPressed: () {
              setState(() => _targetValue += _getIncrement());
            },
            theme: theme,
          ),
        ],
      ),
    );
  }

  String _getUnitLabel() {
    switch (_selectedGoalType) {
      case 'minutes':
        return 'دقيقة';
      case 'pages':
        return 'صفحة';
      case 'azkar':
        return 'ذكر';
      default:
        return 'مرة';
    }
  }

  int _getIncrement() {
    switch (_selectedGoalType) {
      case 'minutes':
        return 5;
      case 'pages':
        return 1;
      case 'azkar':
        return 10;
      default:
        return 1;
    }
  }

  Future<void> _saveGoal() async {
    final db = ref.read(appDatabaseProvider);
    String metric = 'quran_pages';
    switch (_selectedGoalType) {
      case 'minutes':
        metric = 'quran_minutes';
        break;
      case 'azkar':
        metric = 'azkar_count';
        break;
      case 'hadith':
        metric = 'hadith_count';
        break;
      case 'muhasaba':
        metric = 'muhasaba_done';
        break;
      default:
        metric = 'quran_pages';
        break;
    }

    await db
        .into(db.userGoalsTable)
        .insert(
          UserGoalsTableCompanion.insert(
            goalType: _selectedGoalType,
            metric: drift.Value(metric),
            targetValue: _targetValue,
            title: _selectedGoalType, // Fallback default title
            icon: 'flag', // Fallback default icon
            updatedAt: DateTime.now().toIso8601String(),
          ),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ الهدف بنجاح!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      );
      context.pop();
    }
  }
}

class _AdjustButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final ThemeData theme;

  const _AdjustButton({
    required this.icon,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Icon(icon, size: 32, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}

class _GoalTypeSelector extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalTypeSelector({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.card : AppShadows.minimal,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
