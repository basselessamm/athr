import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/library/modules/recent_activity/providers/recent_activity_providers.dart';
import 'package:athr/features/library/presentation/widgets/recent_activity_timeline.dart';
import 'package:athr/features/home/presentation/sections/continue_reading_card.dart';

import 'package:athr/features/library/domain/entities/saved_item_type.dart';
import 'package:athr/features/library/modules/saved_quran/presentation/saved_quran_section.dart';
import 'package:athr/features/library/modules/saved_hadith/presentation/saved_hadith_section.dart';
import 'package:athr/features/library/modules/saved_azkar/presentation/saved_azkar_section.dart';
import 'package:athr/features/library/modules/notes/presentation/notes_section.dart';
import 'package:athr/features/library/modules/notes/providers/notes_providers.dart';
import 'package:athr/features/library/modules/statistics/presentation/statistics_section.dart';
import 'package:athr/features/library/providers/saved_items_providers.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentActivitiesAsync = ref.watch(recentActivitiesProvider);
    final quranSavedAsync = ref.watch(savedItemsProvider(SavedItemType.quran));
    final hadithSavedAsync = ref.watch(
      savedItemsProvider(SavedItemType.hadith),
    );
    final azkarSavedAsync = ref.watch(savedItemsProvider(SavedItemType.azkar));
    final notesAsync = ref.watch(notesProvider);

    final recentActivities =
        recentActivitiesAsync.valueOrNull ?? const <RecentActivity>[];
    final quranItems = quranSavedAsync.valueOrNull ?? const <SavedItem>[];
    final hadithItems = hadithSavedAsync.valueOrNull ?? const <SavedItem>[];
    final azkarItems = azkarSavedAsync.valueOrNull ?? const <SavedItem>[];
    final notes = notesAsync.valueOrNull ?? const <UserNote>[];

    final latestMuhasaba = _findLatestActivityByType(
      recentActivities,
      'muhasaba',
    );
    final latestSaved = _findLatestSavedItem([
      quranItems,
      hadithItems,
      azkarItems,
    ]);
    final latestNote = notes.isNotEmpty ? notes.first : null;
    final totalSavedCount =
        quranItems.length + hadithItems.length + azkarItems.length;

    return AthrScaffold(
      title: 'مكتبتي',
      extendBody: true,
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 4),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddNoteDialog(context, ref),
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('ملاحظة جديدة'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.secondary.withValues(alpha: 0.05),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.24, 1.0],
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
                  132,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LibraryHero(
                      totalSavedCount: totalSavedCount,
                      notesCount: notes.length,
                      recentActivitiesCount: recentActivities.length,
                      latestNote: latestNote,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _OverviewMetricsRow(
                      quranCount: quranItems.length,
                      hadithCount: hadithItems.length,
                      azkarCount: azkarItems.length,
                      notesCount: notes.length,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _SectionHeading(
                      eyebrow: 'محطاتك الأخيرة',
                      title: 'آخر ما عدت إليه في مكتبتك',
                      subtitle:
                          'اجمع آخر قراءة وآخر محاسبة وآخر ما حفظته لتكمل يومك من حيث توقفت.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const ContinueReadingCard(),
                    const SizedBox(height: AppSpacing.md),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 460;
                        final cardWidth = compact
                            ? constraints.maxWidth
                            : (constraints.maxWidth - AppSpacing.md) / 2;

                        return Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: [
                            SizedBox(
                              width: cardWidth,
                              child: _SnapshotCard(
                                title: 'آخر محاسبة',
                                headline:
                                    latestMuhasaba?.title ??
                                    'لم تسجل محاسبة بعد',
                                supporting:
                                    latestMuhasaba?.subtitle ??
                                    'أضف مراجعة سريعة ليومك لتظهر هنا مباشرة.',
                                icon: Icons.assignment_turned_in_rounded,
                                accentColor: const Color(0xFF7A6242),
                                actionLabel: latestMuhasaba == null
                                    ? 'افتح المحاسبة'
                                    : 'متابعة',
                                onTap: () {
                                  if (latestMuhasaba != null) {
                                    context.push(latestMuhasaba.routePath);
                                  } else {
                                    context.push('/muhasaba');
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _SnapshotCard(
                                title: 'آخر عنصر محفوظ',
                                headline:
                                    latestSaved?.previewText ??
                                    'لا توجد محفوظات بعد',
                                supporting: latestSaved == null
                                    ? 'احفظ آية أو حديثاً أو ذكراً ليظهر هنا آخر ما اخترته.'
                                    : _savedItemSummary(latestSaved),
                                icon: _savedItemIcon(latestSaved),
                                accentColor: _savedItemColor(latestSaved),
                                actionLabel: latestSaved == null
                                    ? 'تصفح المحتوى'
                                    : 'افتح العنصر',
                                onTap: () {
                                  if (latestSaved != null) {
                                    context.push(_savedItemRoute(latestSaved));
                                  } else {
                                    context.push('/quran');
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _LibrarySectionShell(
                      title: 'رفوف المحفوظات',
                      subtitle:
                          'مرتبّة بحسب نوع المحتوى لتعود لما حفظته سريعاً وبدون تشتيت.',
                      icon: Icons.bookmarks_rounded,
                      accentColor: theme.colorScheme.primary,
                      child: Column(
                        children: [
                          _LibraryCategoryBlock(
                            title: 'القرآن المحفوظ',
                            subtitle:
                                'آيات وسور حفظتها لتبقى قريبة من لحظاتك اليومية.',
                            actionLabel: 'تصفح القرآن',
                            onAction: () => context.go('/quran'),
                            child: SavedQuranSection(
                              onItemPressed: (item) =>
                                  context.push('/quran/${item.referenceId}'),
                              onBrowsePressed: () => context.go('/quran'),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _LibraryCategoryBlock(
                            title: 'الأحاديث المحفوظة',
                            subtitle:
                                'راجع الأحاديث التي اخترتها لتكون مرجعاً سريعاً لك.',
                            actionLabel: 'تصفح الأحاديث',
                            onAction: () => context.go('/hadith'),
                            child: SavedHadithSection(
                              onItemPressed: (item) => context.push('/hadith'),
                              onBrowsePressed: () => context.go('/hadith'),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _LibraryCategoryBlock(
                            title: 'الأذكار المحفوظة',
                            subtitle:
                                'أذكارك الأقرب لك، محفوظة لتصل إليها في أي وقت.',
                            actionLabel: 'تصفح الأذكار',
                            onAction: () => context.go('/azkar'),
                            child: SavedAzkarSection(
                              onItemPressed: (item) =>
                                  context.push('/azkar/${item.previewText}'),
                              onBrowsePressed: () => context.go('/azkar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _LibrarySectionShell(
                      title: 'ملاحظاتي',
                      subtitle:
                          'التقط خواطرك وتأملاتك لتظل مرتبطة بما قرأت أو حفظت.',
                      icon: Icons.sticky_note_2_rounded,
                      accentColor: theme.colorScheme.tertiary,
                      actionLabel: 'إضافة ملاحظة',
                      onAction: () => _showAddNoteDialog(context, ref),
                      child: NotesSection(
                        onNotePressed: (note) =>
                            _showNoteDetails(context, note),
                        onCreatePressed: () => _showAddNoteDialog(context, ref),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _LibrarySectionShell(
                      title: 'سجل النشاط الأخير',
                      subtitle:
                          'مرور زمني سريع على آخر انتقالاتك داخل التطبيق.',
                      icon: Icons.timeline_rounded,
                      accentColor: theme.colorScheme.secondary,
                      child: recentActivitiesAsync.when(
                        data: (activities) =>
                            RecentActivityTimeline(activities: activities),
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.xl,
                          ),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (err, stack) => _InlineErrorState(
                          message: 'حدث خطأ أثناء تحميل النشاط الأخير.',
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const StatisticsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Text('إضافة ملاحظة جديدة'),
          content: TextField(
            controller: textController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'اكتب ملاحظتك هنا...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  ref
                      .read(notesRepositoryProvider)
                      .addNote(textController.text.trim());
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حفظ الملاحظة بنجاح')),
                  );
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  void _showNoteDetails(BuildContext context, dynamic note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Text('تفاصيل الملاحظة'),
          content: SingleChildScrollView(child: Text(note.content)),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }
}

class _LibraryHero extends StatelessWidget {
  final int totalSavedCount;
  final int notesCount;
  final int recentActivitiesCount;
  final UserNote? latestNote;

  const _LibraryHero({
    required this.totalSavedCount,
    required this.notesCount,
    required this.recentActivitiesCount,
    required this.latestNote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            theme.colorScheme.secondaryContainer,
            Color.lerp(
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.surface,
                  0.2,
                ) ??
                theme.colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _HeroPill(
                icon: Icons.auto_stories_rounded,
                label: '$totalSavedCount محفوظ',
              ),
              _HeroPill(
                icon: Icons.history_rounded,
                label: '$recentActivitiesCount نشاطات أخيرة',
              ),
              _HeroPill(
                icon: Icons.edit_note_rounded,
                label: '$notesCount ملاحظات',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'مكتبتك الشخصية جاهزة للرجوع السريع',
            style: AppTypography.cairoTextTheme().headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'هنا تجد آخر ما قرأتَه، وما حفظتَه، وما دوّنتَه في مساحة واحدة تساعدك على الاستمرار بدون فقدان السياق.',
            style: AppTypography.cairoTextTheme().bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.7,
            ),
          ),
          if (latestNote != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'آخر تأمل كتبته',
                          style: AppTypography.cairoTextTheme().labelLarge
                              ?.copyWith(
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          latestNote!.content,
                          style: AppTypography.cairoTextTheme().bodyMedium
                              ?.copyWith(
                                color: theme.colorScheme.onSurface,
                                height: 1.6,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.cairoTextTheme().labelLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewMetricsRow extends StatelessWidget {
  final int quranCount;
  final int hadithCount;
  final int azkarCount;
  final int notesCount;

  const _OverviewMetricsRow({
    required this.quranCount,
    required this.hadithCount,
    required this.azkarCount,
    required this.notesCount,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _OverviewMetricData(
        label: 'القرآن',
        value: quranCount,
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF3E6B5B),
      ),
      _OverviewMetricData(
        label: 'الحديث',
        value: hadithCount,
        icon: Icons.library_books_rounded,
        color: const Color(0xFF7A6242),
      ),
      _OverviewMetricData(
        label: 'الأذكار',
        value: azkarCount,
        icon: Icons.wb_sunny_outlined,
        color: const Color(0xFF8C6D2D),
      ),
      _OverviewMetricData(
        label: 'ملاحظات',
        value: notesCount,
        icon: Icons.sticky_note_2_rounded,
        color: const Color(0xFF6A5178),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final spacing = AppSpacing.md;
        final itemWidth = compact
            ? (constraints.maxWidth - spacing) / 2
            : (constraints.maxWidth - (spacing * 3)) / 4;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: metrics.map((metric) {
            return SizedBox(
              width: itemWidth,
              child: _OverviewMetricCard(metric: metric),
            );
          }).toList(),
        );
      },
    );
  }
}

class _OverviewMetricData {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _OverviewMetricData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _OverviewMetricCard extends StatelessWidget {
  final _OverviewMetricData metric;

  const _OverviewMetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            metric.color.withValues(alpha: 0.12),
            theme.colorScheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: metric.color.withValues(alpha: 0.14)),
        boxShadow: AppShadows.minimal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: metric.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(metric.icon, color: metric.color),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${metric.value}',
            style: AppTypography.cairoTextTheme().headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            metric.label,
            style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: AppTypography.cairoTextTheme().labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: AppTypography.cairoTextTheme().titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _SnapshotCard extends StatelessWidget {
  final String title;
  final String headline;
  final String supporting;
  final IconData icon;
  final Color accentColor;
  final String actionLabel;
  final VoidCallback onTap;

  const _SnapshotCard({
    required this.title,
    required this.headline,
    required this.supporting,
    required this.icon,
    required this.accentColor,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Ink(
        constraints: const BoxConstraints(minHeight: 176),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              accentColor.withValues(alpha: 0.12),
              theme.colorScheme.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: accentColor.withValues(alpha: 0.18)),
          boxShadow: AppShadows.minimal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: accentColor),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.cairoTextTheme().labelLarge?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  headline,
                  style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    height: 1.45,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  supporting,
                  style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.55,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  actionLabel,
                  style: AppTypography.cairoTextTheme().labelLarge?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.arrow_back_rounded, size: 18, color: accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LibrarySectionShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget child;

  const _LibrarySectionShell({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.actionLabel,
    this.onAction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: AppShadows.minimal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: accentColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.cairoTextTheme().titleLarge
                          ?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.cairoTextTheme().bodyMedium
                          ?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.6,
                          ),
                    ),
                  ],
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(width: AppSpacing.sm),
                TextButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _LibraryCategoryBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;
  final Widget child;

  const _LibraryCategoryBlock({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
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
                      title,
                      style: AppTypography.cairoTextTheme().titleMedium
                          ?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(onPressed: onAction, child: Text(actionLabel)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _InlineErrorState extends StatelessWidget {
  final String message;

  const _InlineErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        message,
        style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}

RecentActivity? _findLatestActivityByType(
  List<RecentActivity> activities,
  String type,
) {
  for (final activity in activities) {
    if (activity.type == type) {
      return activity;
    }
  }
  return null;
}

SavedItem? _findLatestSavedItem(List<List<SavedItem>> groups) {
  SavedItem? latest;

  for (final group in groups) {
    if (group.isEmpty) {
      continue;
    }

    final candidate = group.first;
    final candidateDate =
        DateTime.tryParse(candidate.createdAt) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final latestDate = latest == null
        ? DateTime.fromMillisecondsSinceEpoch(0)
        : DateTime.tryParse(latest.createdAt) ??
              DateTime.fromMillisecondsSinceEpoch(0);

    if (latest == null || candidateDate.isAfter(latestDate)) {
      latest = candidate;
    }
  }

  return latest;
}

String _savedItemSummary(SavedItem item) {
  switch (item.featureType) {
    case 'quran':
      return 'سورة ${item.referenceId}${item.secondaryId != null ? ' • آية ${item.secondaryId}' : ''}';
    case 'hadith':
      return 'حديث محفوظ للرجوع السريع';
    case 'azkar':
      return 'ذكر محفوظ من قسم ${item.referenceId}';
    default:
      return 'عنصر محفوظ حديثاً';
  }
}

String _savedItemRoute(SavedItem item) {
  switch (item.featureType) {
    case 'quran':
      return '/quran/${item.referenceId}';
    case 'hadith':
      return '/hadith';
    case 'azkar':
      return '/azkar/${item.previewText}';
    default:
      return '/library';
  }
}

IconData _savedItemIcon(SavedItem? item) {
  switch (item?.featureType) {
    case 'quran':
      return Icons.menu_book_rounded;
    case 'hadith':
      return Icons.library_books_rounded;
    case 'azkar':
      return Icons.favorite_rounded;
    default:
      return Icons.bookmark_add_rounded;
  }
}

Color _savedItemColor(SavedItem? item) {
  switch (item?.featureType) {
    case 'quran':
      return const Color(0xFF3E6B5B);
    case 'hadith':
      return const Color(0xFF7A6242);
    case 'azkar':
      return const Color(0xFF8C6D2D);
    default:
      return const Color(0xFF5E6A73);
  }
}
