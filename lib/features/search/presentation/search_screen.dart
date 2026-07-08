import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/search/providers/search_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final theme = Theme.of(context);
    final fontSize = ref.watch(fontSizeProvider);

    return AthrScaffold(
      title: 'البحث الشامل',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'ابحث في القرآن، الأحاديث، أو الأذكار...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchProvider.notifier).updateQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
              ),
              onChanged: (value) {
                ref.read(searchProvider.notifier).updateQuery(value);
              },
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'القرآن الكريم'),
              Tab(text: 'الأحاديث'),
              Tab(text: 'الأذكار'),
            ],
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
          ),
          Expanded(
            child: searchState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildQuranResults(
                        searchState.quranResults,
                        searchState.query,
                        fontSize,
                      ),
                      _buildHadithResults(
                        searchState.hadithResults,
                        searchState.query,
                        fontSize,
                      ),
                      _buildAzkarResults(
                        searchState.azkarResults,
                        searchState.query,
                        fontSize,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String query) {
    if (query.isEmpty) {
      return const Center(child: Text('اكتب للبحث...'));
    }
    return const Center(child: Text('لم يتم العثور على نتائج.'));
  }

  Widget _buildQuranResults(
    List<QuranSearchResult> results,
    String query,
    double fontSize,
  ) {
    if (results.isEmpty) return _buildEmptyState(query);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        final surahName = Quran.getSurahName(result.surah);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              result.text,
              style: GoogleFonts.amiri(fontSize: fontSize, height: 1.8),
              textDirection: TextDirection.rtl,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'سورة $surahName - آية ${result.ayah}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            onTap: () {
              context.push('/quran/${result.surah}');
            },
          ),
        );
      },
    );
  }

  Widget _buildHadithResults(
    List<dynamic> results,
    String query,
    double fontSize,
  ) {
    if (results.isEmpty) return _buildEmptyState(query);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final hadith = results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              hadith.hadithTextAr,
              style: GoogleFonts.amiri(fontSize: fontSize, height: 1.8),
              textDirection: TextDirection.rtl,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                '${hadith.bookName} - ${hadith.chapterName}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            onTap: () {
              if (hadith.bookName != null) {
                context.pushNamed('hadithReading', pathParameters: {'bookName': hadith.bookName!});
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildAzkarResults(
    List<dynamic> results,
    String query,
    double fontSize,
  ) {
    if (results.isEmpty) return _buildEmptyState(query);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final dua = results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              dua.duaText,
              style: GoogleFonts.amiri(fontSize: fontSize, height: 1.8),
              textDirection: TextDirection.rtl,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                dua.category ?? 'ذكر',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        );
      },
    );
  }
}
