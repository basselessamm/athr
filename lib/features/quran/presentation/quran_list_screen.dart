import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/quran/presentation/widgets/surah_list_tile.dart';
import 'package:athr/features/quran/providers/bookmark_provider.dart';
import 'package:athr/features/quran/providers/quran_providers.dart';

class QuranListScreen extends ConsumerWidget {
  const QuranListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quranInitialization = ref.watch(quranInitializationProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (quranInitialization.isLoading) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AthrScaffold(
          title: 'القرآن الكريم',
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: scheme.primary),
                const SizedBox(height: 16),
                Text(
                  'يُهيَّأ المصحف للقراءة…',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          bottomNavigationBar: const MainNavigationBar(selectedIndex: 1),
        ),
      );
    }

    if (quranInitialization.hasError) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AthrScaffold(
          title: 'القرآن الكريم',
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'تعذرت تهيئة المصحف الآن. حاول مرة أخرى بعد قليل.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
          bottomNavigationBar: const MainNavigationBar(selectedIndex: 1),
        ),
      );
    }

    final bookmark = ref.watch(bookmarkProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AthrScaffold(
        title: 'القرآن الكريم',
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 10),
                child: Semantics(
                  header: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'اقرأ على مهل',
                        style: GoogleFonts.amiri(
                          fontSize: 30,
                          height: 1.15,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'اختر سورة، ثم اضغط على الآية التي تريد العودة إليها.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.65,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (bookmark != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 14),
                  child: Semantics(
                    button: true,
                    label:
                        'إكمال القراءة من سورة ${Quran.getSurahName(bookmark.surah)}، الآية ${bookmark.ayah}',
                    child: Material(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => context.push(
                          '/quran/${bookmark.surah}?ayah=${bookmark.ayah}',
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: scheme.primary.withValues(alpha: 0.13),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.menu_book_rounded,
                                  color: scheme.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'إكمال القراءة',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: scheme.onPrimaryContainer
                                                .withValues(alpha: 0.72),
                                          ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'سورة ${Quran.getSurahName(bookmark.surah)} · الآية ${bookmark.ayah}',
                                      style: GoogleFonts.amiri(
                                        fontSize: 23,
                                        height: 1.15,
                                        fontWeight: FontWeight.w700,
                                        color: scheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: scheme.primary,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 2, 20, 8),
                child: Text(
                  'السور',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: 114,
              itemBuilder: (context, index) =>
                  SurahListTile(surahNumber: index + 1),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 18)),
          ],
        ),
        bottomNavigationBar: const MainNavigationBar(selectedIndex: 1),
      ),
    );
  }
}
