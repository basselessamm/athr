import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/core/widgets/midrar_scaffold.dart';
import 'package:midrar/features/hadith/providers/hadith_providers.dart';

class HadithChaptersScreen extends ConsumerStatefulWidget {
  final String bookName;

  const HadithChaptersScreen({
    super.key,
    required this.bookName,
  });

  @override
  ConsumerState<HadithChaptersScreen> createState() =>
      _HadithChaptersScreenState();
}

class _HadithChaptersScreenState extends ConsumerState<HadithChaptersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getArabicBookName(String name) {
    if (name.toLowerCase().contains('bukhari') || name.contains('البخاري')) {
      return 'صحيح البخاري';
    }
    if (name.toLowerCase().contains('muslim') || name.contains('مسلم')) {
      return 'صحيح مسلم';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final arabicTitle = _getArabicBookName(widget.bookName);
    final chaptersAsync = ref.watch(hadithChaptersProvider(widget.bookName));
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MidrarScaffold(
        title: 'أبواب $arabicTitle',
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: InputDecoration(
                  hintText: 'ابحث في أبواب وفصول الكتاب...',
                  prefixIcon: Icon(Icons.search_rounded, color: scheme.primary),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: scheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: scheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: scheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: scheme.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: chaptersAsync.when(
                data: (chapters) {
                  final filtered = _searchQuery.isEmpty
                      ? chapters
                      : chapters
                          .where(
                            (c) => c.chapterName.contains(_searchQuery),
                          )
                          .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isEmpty
                                ? 'لا توجد أبواب مسجلة في هذا الكتاب'
                                : 'لا يوجد باب يطابق: "$_searchQuery"',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: scheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          elevation: 0,
                          child: InkWell(
                            onTap: () {
                              context.push(
                                Uri(
                                  path: '/hadith/${widget.bookName}',
                                  queryParameters: {
                                    'chapter': item.chapterName,
                                  },
                                ).toString(),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: scheme.outline.withValues(alpha: 0.35),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.black.withValues(alpha: 0.15)
                                        : const Color(0xFF1C443B)
                                            .withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: scheme.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: scheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.chapterName,
                                          style: GoogleFonts.amiri(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: scheme.onSurface,
                                            height: 1.3,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${item.hadithCount} حديث',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: scheme.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 14,
                                    color: scheme.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, st) => Center(
                  child: Text('تعذر تحميل الأبواب: $err'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
