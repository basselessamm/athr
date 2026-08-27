import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/core/theme/app_colors.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/widgets/midrar_scaffold.dart';
import 'package:midrar/features/azkar/providers/azkar_providers.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';
import 'package:midrar/features/situations/providers/situations_providers.dart';

class SituationDetailScreen extends ConsumerWidget {
  final String id;

  const SituationDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final situation = ref.watch(situationByIdProvider(id));
    final content = ref.watch(situationContentProvider(id));
    final duasAsync = ref.watch(azkarByCategoryProvider(situation.duaCategory));
    final hadithsAsync = ref.watch(situationHadithProvider(id));
    final fontSize = ref.watch(fontSizeProvider);

    return MidrarScaffold(
      title: situation.title,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _IntroCard(
            id: situation.id,
            title: situation.title,
            description: content.intro,
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'خطوات عملية وتوجيه',
            child: Column(
              children: content.actionSteps
                  .map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              step,
                              style: const TextStyle(height: 1.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'آيات مناسبة لهذا الموقف',
            child: Column(
              children: content.verses.map((verseRef) {
                final verse = Quran.getVerse(
                  surahNumber: verseRef.surahNumber,
                  verseNumber: verseRef.ayahNumber,
                ).text;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        verse,
                        style: GoogleFonts.amiri(
                          fontSize: fontSize,
                          height: 1.9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        verseRef.sourceLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'أدعية مأثورة',
            child: duasAsync.when(
              data: (duas) {
                if (duas.isEmpty) {
                  return const Text('لا توجد أدعية مسجلة لهذا القسم حالياً.');
                }
                return Column(
                  children: duas.take(4).map((dua) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            dua.duaText,
                            style: GoogleFonts.amiri(
                              fontSize: fontSize,
                              height: 1.9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (dua.reference != null &&
                              dua.reference!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              dua.reference!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
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
              error: (error, stackTrace) => Text('تعذر تحميل الأدعية: $error'),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'أحاديث نبوية مرتبطة',
            child: hadithsAsync.when(
              data: (hadiths) {
                if (hadiths.isEmpty) {
                  return const Text('لا توجد أحاديث مسجلة لهذا الموقف حالياً.');
                }
                final typedHadiths = hadiths.cast<Hadith>();
                return Column(
                  children: typedHadiths.map((hadith) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            hadith.hadithTextAr,
                            style: GoogleFonts.amiri(
                              fontSize: fontSize - 2,
                              height: 1.8,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            hadith.reference ?? hadith.bookName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('تعذر تحميل الأحاديث: $error'),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;

  const _IntroCard({
    required this.id,
    required this.title,
    required this.description,
  });

  (IconData, Color) _getVisual(String id) {
    switch (id) {
      case '1':
        return (Icons.healing_outlined, AppColors.emotionComfort);
      case '2':
        return (Icons.wb_twilight_outlined, AppColors.emotionTranquility);
      case '3':
        return (Icons.explore_outlined, AppColors.emotionHope);
      case '4':
        return (Icons.shield_outlined, AppColors.emotionTranquility);
      case '5':
        return (Icons.autorenew_rounded, AppColors.emotionReflection);
      case '6':
        return (Icons.verified_outlined, AppColors.emotionHope);
      case '7':
        return (Icons.account_balance_wallet_outlined, AppColors.emotionGratitude);
      case '8':
        return (Icons.water_drop_outlined, AppColors.emotionTranquility);
      default:
        return (Icons.spa_outlined, AppColors.lightAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (icon, accentColor) = _getVisual(id);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(
          alpha: isDark ? 0.45 : 0.65,
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.25 : 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDark ? accentColor.withValues(alpha: 0.95) : accentColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
