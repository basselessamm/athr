import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/azkar/providers/azkar_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';
import 'package:athr/features/situations/providers/situations_providers.dart';

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

    return AthrScaffold(
      title: situation.title,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _IntroCard(
            emoji: situation.emoji,
            title: situation.title,
            description: content.intro,
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'خطوات عملية الآن',
            child: Column(
              children: content.actionSteps
                  .map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(Icons.check_circle_outline, size: 18),
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
            title: 'أذكار وأدعية',
            child: duasAsync.when(
              data: (duas) {
                if (duas.isEmpty) {
                  return const Text('لا توجد أدعية متاحة لهذا الموقف الآن.');
                }

                return Column(
                  children: duas.take(3).map((dua) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        children: [
                          Text(
                            dua.duaText,
                            style: TextStyle(fontSize: fontSize, height: 1.8),
                            textAlign: TextAlign.center,
                          ),
                          if (dua.reference != null &&
                              dua.reference!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              dua.reference!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
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
            title: 'حديث يساند هذا المعنى',
            child: hadithsAsync.when(
              data: (hadiths) {
                if (hadiths.isEmpty) {
                  return const Text(
                    'لا يوجد حديث مطابق محفوظ محليًا لهذا الموقف حتى الآن.',
                  );
                }

                final typedHadiths = hadiths.cast<Hadith>();

                return Column(
                  children: typedHadiths.map<Widget>((hadith) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            hadith.hadithTextAr,
                            style: const TextStyle(fontSize: 17, height: 1.8),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            hadith.reference ?? hadith.bookName,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 34)),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.7),
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
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
