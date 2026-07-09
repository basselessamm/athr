import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/progress/domain/goal_cleanup.dart';
import 'package:athr/features/progress/providers/goal_engine_provider.dart';

const Map<String, _GoalTypeDefinition> _goalDefinitions = {
  'minutes': _GoalTypeDefinition(
    type: 'minutes',
    title: 'دقائق القراءة',
    subtitle: 'خصص وقتاً ثابتاً يومياً للقرآن',
    metric: 'quran_minutes',
    iconName: 'timer',
    icon: Icons.timer_rounded,
    defaultTarget: 30,
    minimumTarget: 5,
    increment: 5,
    unitLabel: 'دقيقة',
  ),
  'pages': _GoalTypeDefinition(
    type: 'pages',
    title: 'عدد الصفحات',
    subtitle: 'حدد ورداً يومياً بعدد الصفحات',
    metric: 'quran_pages',
    iconName: 'menu_book',
    icon: Icons.menu_book_rounded,
    defaultTarget: 10,
    minimumTarget: 1,
    increment: 1,
    unitLabel: 'صفحة',
  ),
  'azkar': _GoalTypeDefinition(
    type: 'azkar',
    title: 'الأذكار المنجزة',
    subtitle: 'حافظ على أورادك اليومية',
    metric: 'azkar_count',
    iconName: 'shield',
    icon: Icons.shield_rounded,
    defaultTarget: 100,
    minimumTarget: 10,
    increment: 10,
    unitLabel: 'ذكر',
  ),
};

class GoalSettingScreen extends ConsumerStatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  ConsumerState<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends ConsumerState<GoalSettingScreen> {
  String _selectedGoalType = 'minutes';
  int _targetValue = 30;
  bool _hydratedFromStoredGoals = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(userGoalsProvider);

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
          child: goalsAsync.when(
            data: (goals) {
              _hydrateInitialGoalState(goals);

              final selectedDefinition = _goalDefinitions[_selectedGoalType]!;
              final existingGoal = _findLatestGoalForType(
                goals,
                _selectedGoalType,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ما هو هدفك اليومي؟',
                    style: AppTypography.cairoTextTheme().headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'اختر المقياس الذي تود الالتزام به يومياً وسنساعدك في تتبعه بدقة.',
                    style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      boxShadow: AppShadows.minimal,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Icon(
                            existingGoal == null
                                ? Icons.add_task_rounded
                                : Icons.edit_note_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                existingGoal == null
                                    ? 'سيتم إنشاء هدف جديد'
                                    : 'سيتم تحديث الهدف الحالي',
                                style: AppTypography.cairoTextTheme().titleSmall
                                    ?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                existingGoal == null
                                    ? 'عند الحفظ سيُضاف هذا النوع إلى أهدافك اليومية.'
                                    : 'القيمة الحالية لهذا النوع هي ${existingGoal.targetValue} ${selectedDefinition.unitLabel}.',
                                style: AppTypography.cairoTextTheme().bodyMedium
                                    ?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      height: 1.5,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  ..._goalDefinitions.values.map((definition) {
                    final isLast =
                        definition.type == _goalDefinitions.values.last.type;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLast ? 0 : AppSpacing.md,
                      ),
                      child: _GoalTypeSelector(
                        title: definition.title,
                        subtitle: definition.subtitle,
                        icon: definition.icon,
                        isSelected: _selectedGoalType == definition.type,
                        onTap: () => _selectGoalType(definition.type, goals),
                      ),
                    );
                  }),
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
                  _buildTargetAdjuster(theme, selectedDefinition),
                  const SizedBox(height: AppSpacing.xxl),
                  ElevatedButton(
                    onPressed: _isSaving ? null : () => _saveGoal(goals),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      elevation: 4,
                      shadowColor: theme.colorScheme.primary.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            existingGoal == null
                                ? 'حفظ الهدف وتفعيله'
                                : 'تحديث الهدف الحالي',
                            style: AppTypography.cairoTextTheme().titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text('تعذر تحميل الأهداف الحالية: $error')),
          ),
        ),
      ),
    );
  }

  Widget _buildTargetAdjuster(ThemeData theme, _GoalTypeDefinition definition) {
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
              final nextValue = _targetValue - definition.increment;
              if (nextValue >= definition.minimumTarget) {
                setState(() => _targetValue = nextValue);
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
                definition.unitLabel,
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
              setState(() => _targetValue += definition.increment);
            },
            theme: theme,
          ),
        ],
      ),
    );
  }

  void _hydrateInitialGoalState(List<UserGoal> goals) {
    if (_hydratedFromStoredGoals) {
      return;
    }

    final latestGoal = _findLatestSupportedGoal(goals);
    final definition = latestGoal == null
        ? _goalDefinitions[_selectedGoalType]!
        : _goalDefinitions[latestGoal.goalType] ??
              _goalDefinitions[_selectedGoalType]!;

    _selectedGoalType = definition.type;
    _targetValue = latestGoal?.targetValue ?? definition.defaultTarget;
    _hydratedFromStoredGoals = true;
  }

  void _selectGoalType(String goalType, List<UserGoal> goals) {
    final definition = _goalDefinitions[goalType]!;
    final existingGoal = _findLatestGoalForType(goals, goalType);

    setState(() {
      _selectedGoalType = goalType;
      _targetValue = existingGoal?.targetValue ?? definition.defaultTarget;
    });
  }

  Future<void> _saveGoal(List<UserGoal> goals) async {
    final repository = ref.read(userGoalsRepositoryProvider);
    final definition = _goalDefinitions[_selectedGoalType]!;
    final matchingGoals =
        goals.where((goal) => goal.goalType == _selectedGoalType).toList()
          ..sort(compareGoalRecencyDescending);

    final primaryExistingGoal = matchingGoals.isNotEmpty
        ? matchingGoals.first
        : null;
    final duplicateGoals = findDuplicateGoalsToDelete(
      goals,
      _goalDefinitions.keys.toSet(),
    );

    setState(() => _isSaving = true);

    try {
      await repository.addOrUpdateGoal(
        id: primaryExistingGoal?.id,
        goalType: definition.type,
        metric: definition.metric,
        title: definition.title,
        icon: definition.iconName,
        targetValue: _targetValue,
        resetPolicy: 'daily',
        metadata: null,
      );

      for (final duplicateGoal in duplicateGoals) {
        await repository.deleteGoal(duplicateGoal.id);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              primaryExistingGoal == null
                  ? 'تم حفظ الهدف بنجاح'
                  : 'تم تحديث الهدف بنجاح',
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تعذر حفظ الهدف. حاول مرة أخرى.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  UserGoal? _findLatestSupportedGoal(List<UserGoal> goals) {
    final supportedGoals =
        goals
            .where((goal) => _goalDefinitions.containsKey(goal.goalType))
            .toList()
          ..sort(compareGoalRecencyDescending);

    return supportedGoals.isNotEmpty ? supportedGoals.first : null;
  }

  UserGoal? _findLatestGoalForType(List<UserGoal> goals, String goalType) {
    final matchingGoals =
        goals.where((goal) => goal.goalType == goalType).toList()
          ..sort(compareGoalRecencyDescending);

    return matchingGoals.isNotEmpty ? matchingGoals.first : null;
  }
}

class _GoalTypeDefinition {
  final String type;
  final String title;
  final String subtitle;
  final String metric;
  final String iconName;
  final IconData icon;
  final int defaultTarget;
  final int minimumTarget;
  final int increment;
  final String unitLabel;

  const _GoalTypeDefinition({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.metric,
    required this.iconName,
    required this.icon,
    required this.defaultTarget,
    required this.minimumTarget,
    required this.increment,
    required this.unitLabel,
  });
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
