import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_flutter/quran.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/quran/presentation/widgets/surah_list_tile.dart';
import 'package:athr/features/quran/providers/bookmark_provider.dart';

class QuranListScreen extends ConsumerWidget {
  const QuranListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmark = ref.watch(bookmarkProvider);

    return AthrScaffold(
      title: 'القرآن الكريم',
      body: Column(
        children: [
          if (bookmark != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    context.push('/quran/${bookmark.surah}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إكمال القراءة',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'سورة ${Quran.getSurahName(bookmark.surah)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.bookmark,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.separated(
              itemCount: 114,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final surahNumber = index + 1;
                return SurahListTile(surahNumber: surahNumber);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 1),
    );
  }
}
