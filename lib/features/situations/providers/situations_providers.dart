import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/features/situations/data/situations_content.dart';

class Situation {
  final String id;
  final String title;
  final String emoji;
  final String duaCategory;
  final String description;

  const Situation({
    required this.id,
    required this.title,
    required this.emoji,
    required this.duaCategory,
    required this.description,
  });
}

const List<Situation> lifeSituations = [
  Situation(
    id: '1',
    title: 'عند الهم والحزن',
    emoji: '😔',
    duaCategory: 'دعاء الهم والحزن',
    description: 'أدعية تريح القلب وتذهب الهموم والأحزان.',
  ),
  Situation(
    id: '2',
    title: 'عند الكرب والضيق',
    emoji: '😓',
    duaCategory: 'دعاء الكرب',
    description: 'أدعية لفك الكروب والشدائد وتفريج الأزمات.',
  ),
  Situation(
    id: '3',
    title: 'عند تعسر الأمور',
    emoji: '🚧',
    duaCategory: 'دعاء من استصعب عليه أمر',
    description: 'أدعية لتيسير الأمور الصعبة وقضاء الحوائج.',
  ),
  Situation(
    id: '4',
    title: 'عند القلق والفزع',
    emoji: '😨',
    duaCategory: 'دعاء القلق والفزع في النوم ومن بلي بالوحشة',
    description: 'أدعية تبث الطمأنينة وتذهب الخوف والقلق.',
  ),
  Situation(
    id: '5',
    title: 'عند الوقوع في ذنب',
    emoji: '💔',
    duaCategory: 'ما يقول ويفعل من أذنب ذنباً',
    description: 'الرجوع إلى الله وطلب المغفرة والتوبة السريعة.',
  ),
  Situation(
    id: '6',
    title: 'عند الشك في الإيمان',
    emoji: '🤔',
    duaCategory: 'دعاء من أصابه شك في الإيمان',
    description: 'تثبيت القلب ودفع وساوس الشيطان.',
  ),
  Situation(
    id: '7',
    title: 'عند قضاء الدين',
    emoji: '💰',
    duaCategory: 'الدعاء قضاء الدين',
    description: 'الاستعانة بالله لسداد الديون والبركة في الرزق.',
  ),
  Situation(
    id: '8',
    title: 'عند الغضب',
    emoji: '😡',
    duaCategory: 'دعاء الغضب',
    description: 'الاستعاذة بالله والتحكم في النفس عند الغضب.',
  ),
];

final situationsProvider = Provider<List<Situation>>((ref) {
  return lifeSituations;
});

final situationByIdProvider = Provider.family<Situation, String>((ref, id) {
  return lifeSituations.firstWhere(
    (item) => item.id == id,
    orElse: () => lifeSituations.first,
  );
});

final situationContentProvider = Provider.family<SituationContentBlock, String>(
  (ref, id) {
    return situationsContent[id] ?? situationsContent.values.first;
  },
);

/// Resolves supporting hadiths for a life situation by querying the FULL
/// local corpus through an indexed SQL predicate. Chapter keywords are
/// matched against every row of the requested book (deterministic order),
/// never against an arbitrary window, so content that exists locally is
/// always found.
final situationHadithProvider = FutureProvider.family<List<Hadith>, String>((
  ref,
  id,
) async {
  final db = ref.watch(appDatabaseProvider);
  final content = ref.watch(situationContentProvider(id));
  final items = <Hadith>[];

  const maxPerReference = 1;
  const maxTotal = 3;

  for (final reference in content.hadiths) {
    if (items.length >= maxTotal) break;
    final keyword = reference.chapterKeyword.trim();
    if (keyword.isEmpty) continue;

    // Primary path: chapter-name match across the entire book using the
    // (book_name, id) index; deterministic ordering keeps results stable.
    var matches = await (db.select(db.hadithTable)
          ..where(
            (t) =>
                t.bookName.equals(reference.bookName) &
                t.chapterName.like('%$keyword%'),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.id)])
          ..limit(maxPerReference))
        .get();

    // Fallback path: full-text match over the normalized corpus when the
    // keyword describes content rather than a chapter heading.
    if (matches.isEmpty) {
      matches = await (db.select(db.hadithTable)
            ..where(
              (t) =>
                  t.bookName.equals(reference.bookName) &
                  t.hadithTextArNorm.like('%$keyword%'),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.id)])
            ..limit(maxPerReference))
          .get();
    }

    items.addAll(matches);
  }

  return items.take(maxTotal).toList(growable: false);
});
