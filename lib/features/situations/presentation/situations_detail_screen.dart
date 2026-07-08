import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/azkar/providers/azkar_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/features/situations/providers/situations_providers.dart';

class SituationDetailScreen extends ConsumerWidget {
  final String id;

  const SituationDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final situation = ref.watch(situationByIdProvider(id));
    final content = ref.watch(situationContentProvider(id));
    final duasAsync = ref.watch(azkarByCategoryProvider(situation.duaCategory));
    final hadithsAsync = ref.watch(situationHadithProvider(id));
    final fontSize = ref.watch(quranFontSizeProvider);

    return AthrScaffold(
      title: situation.title,
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
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _IntroCard(
              emoji: situation.emoji,
              title: situation.title,
              description: content.intro,
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'خطوات عملية الآن',
              icon: Icons.checklist_rtl_rounded,
              child: Column(
                children: content.actionSteps
                    .map(
                      (step) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                step,
                                style: AppTypography.cairoTextTheme().bodyMedium
                                    ?.copyWith(
                                      height: 1.6,
                                      color: theme.colorScheme.onSurface,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'آيات مناسبة لهذا الموقف',
              icon: Icons.menu_book_rounded,
              child: Column(
                children: content.verses.map((verseRef) {
                  final verse = Quran.getVerse(
                    surahNumber: verseRef.surahNumber,
                    verseNumber: verseRef.ayahNumber,
                  ).text;

                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          verse,
                          style: GoogleFonts.amiri(
                            fontSize: fontSize,
                            height: 2.2,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppRadius.round,
                            ),
                          ),
                          child: Text(
                            verseRef.sourceLabel,
                            style: AppTypography.cairoTextTheme().labelMedium
                                ?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'أذكار وأدعية',
              icon: Icons.volunteer_activism_rounded,
              child: duasAsync.when(
                data: (duas) {
                  if (duas.isEmpty) {
                    return Text(
                      'لا توجد أدعية متاحة لهذا الموقف الآن.',
                      style: AppTypography.cairoTextTheme().bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    );
                  }

                  return Column(
                    children: duas.take(3).map((dua) {
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Column(
                          children: [
                            Text(
                              dua.duaText,
                              style: TextStyle(
                                fontSize: fontSize,
                                height: 2.0,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (dua.reference != null &&
                                dua.reference!.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                dua.reference!,
                                style: AppTypography.cairoTextTheme().bodySmall
                                    ?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Text('تعذر تحميل الأدعية: $error'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'حديث يساند هذا المعنى',
              icon: Icons.format_quote_rounded,
              child: hadithsAsync.when(
                data: (hadiths) {
                  if (hadiths.isEmpty) {
                    return Text(
                      'لا يوجد حديث مطابق محفوظ محليًا لهذا الموقف حتى الآن.',
                      style: AppTypography.cairoTextTheme().bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    );
                  }

                  final typedHadiths = hadiths.cast<Hadith>();

                  return Column(
                    children: typedHadiths.map<Widget>((hadith) {
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              hadith.hadithTextAr,
                              style: TextStyle(
                                fontSize: fontSize - 2,
                                height: 2.0,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              hadith.reference ?? hadith.bookName,
                              style: AppTypography.cairoTextTheme().labelMedium
                                  ?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Text('تعذر تحميل الأحاديث: $error'),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _IntroCard({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTypography.cairoTextTheme().headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
              height: 1.8,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.minimal,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            child,
          ],
        ),
      ),
    );
  }
}
