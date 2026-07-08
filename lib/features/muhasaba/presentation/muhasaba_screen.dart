import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/home/providers/home_providers.dart';

class MuhasabaScreen extends ConsumerStatefulWidget {
  const MuhasabaScreen({super.key});

  @override
  ConsumerState<MuhasabaScreen> createState() => _MuhasabaScreenState();
}

class _MuhasabaScreenState extends ConsumerState<MuhasabaScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool _initialized = false;
  bool _prayed = false;
  bool _guardedTongue = false;
  bool _honoredParents = false;
  bool _avoidedHarm = false;
  bool _gaveCharity = false;
  bool _quranRead = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _seedStateFromEntry(MuhasabaEntry? entry) {
    if (_initialized || entry == null) {
      return;
    }

    _prayed = entry.prayed;
    _guardedTongue = entry.guardedTongue;
    _honoredParents = entry.honoredParents;
    _avoidedHarm = entry.avoidedHarm;
    _gaveCharity = entry.gaveCharity;
    _quranRead = entry.quranRead;
    _noteController.text = entry.note ?? '';
    _initialized = true;
  }

  int get _completedCount {
    int count = 0;
    if (_prayed) count++;
    if (_guardedTongue) count++;
    if (_honoredParents) count++;
    if (_avoidedHarm) count++;
    if (_gaveCharity) count++;
    if (_quranRead) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muhasabaAsync = ref.watch(todayMuhasabaProvider);

    return AthrScaffold(
      title: 'محاسبة النفس',
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
        child: muhasabaAsync.when(
          data: (entry) {
            _seedStateFromEntry(entry);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(theme),
                  const SizedBox(height: AppSpacing.xl),
                  _MuhasabaCheckItem(
                    title: 'هل أديت الصلوات الخمس اليوم في وقتها؟',
                    icon: Icons.access_time_filled_rounded,
                    value: _prayed,
                    onChanged: (value) => setState(() => _prayed = value),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _MuhasabaCheckItem(
                    title: 'هل حفظت لسانك من الغيبة وتجنبت الجدال؟',
                    icon: Icons.record_voice_over_rounded,
                    value: _guardedTongue,
                    onChanged: (value) =>
                        setState(() => _guardedTongue = value),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _MuhasabaCheckItem(
                    title: 'هل بررت والديك أو أدخلت السرور على أحبتك؟',
                    icon: Icons.favorite_rounded,
                    value: _honoredParents,
                    onChanged: (value) =>
                        setState(() => _honoredParents = value),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _MuhasabaCheckItem(
                    title: 'هل عفوت عمن ظلمك أو تجاوزت عن زلة أحدهم؟',
                    icon: Icons.shield_rounded,
                    value: _avoidedHarm,
                    onChanged: (value) => setState(() => _avoidedHarm = value),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _MuhasabaCheckItem(
                    title: 'هل تصدقت اليوم، ولو بابتسامة أو كلمة طيبة؟',
                    icon: Icons.clean_hands_rounded,
                    value: _gaveCharity,
                    onChanged: (value) => setState(() => _gaveCharity = value),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _MuhasabaCheckItem(
                    title: 'هل قرأت وردك من القرآن اليوم؟',
                    icon: Icons.menu_book_rounded,
                    value: _quranRead,
                    onChanged: (value) => setState(() => _quranRead = value),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'فضفضة روح',
                    style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      boxShadow: AppShadows.card,
                    ),
                    child: TextField(
                      controller: _noteController,
                      minLines: 4,
                      maxLines: 6,
                      style: AppTypography.cairoTextTheme().bodyMedium,
                      decoration: InputDecoration(
                        hintText:
                            'كيف كان حال قلبك اليوم؟ اكتب ما تود إصلاحه غدًا...',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  ElevatedButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () async {
                            final messenger = ScaffoldMessenger.of(context);
                            setState(() => _isSaving = true);
                            await ref
                                .read(completionActionsProvider)
                                .saveMuhasaba(
                                  prayed: _prayed,
                                  guardedTongue: _guardedTongue,
                                  honoredParents: _honoredParents,
                                  avoidedHarm: _avoidedHarm,
                                  gaveCharity: _gaveCharity,
                                  quranRead: _quranRead,
                                  note: _noteController.text,
                                );
                            if (mounted) {
                              setState(() => _isSaving = false);
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('تم حفظ محاسبة اليوم بنجاح'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.done_all_rounded),
                    label: Text(
                      'توثيق المحاسبة',
                      style: AppTypography.cairoTextTheme().titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      elevation: 4,
                      shadowColor: theme.colorScheme.primary.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('تعذر تحميل المحاسبة: $error')),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'خلوة المحاسبة',
                      style: AppTypography.cairoTextTheme().titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سجل اليوم كما كان فعلًا، لا كما كنت تتمنى أن يكون. الهدف هو الصدق مع النفس.',
                      style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: _completedCount / 6,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      color: theme.colorScheme.primary,
                      strokeWidth: 6,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    '$_completedCount/6',
                    style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MuhasabaCheckItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MuhasabaCheckItem({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onChanged(!value);
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: value
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: value
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: value ? 2 : 1,
            ),
            boxShadow: value ? AppShadows.card : AppShadows.minimal,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: value
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  value ? Icons.check_rounded : icon,
                  color: value
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                    fontWeight: value ? FontWeight.bold : FontWeight.normal,
                    color: value
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
