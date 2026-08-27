import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/core/widgets/midrar_scaffold.dart';
import 'package:midrar/core/widgets/main_navigation_bar.dart';
import 'package:midrar/features/hadith/providers/hadith_providers.dart';

class HadithBooksScreen extends ConsumerWidget {
  const HadithBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(hadithBooksProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MidrarScaffold(
        title: 'الأحاديث النبوية',
        body: booksAsync.when(
          data: (books) {
            if (books.isEmpty) {
              return const Center(child: Text('لا توجد كتب أحاديث بعد.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                // Map English names to Arabic
                String arabicName = book;
                String description = 'أصح كتب الحديث النبوي الشريف';
                if (book.toLowerCase().contains('bukhari')) {
                  arabicName = 'صحيح البخاري';
                  description = 'الجامع المسند الصحيح المختصر · الإمام البخاري';
                }
                if (book.toLowerCase().contains('muslim')) {
                  arabicName = 'صحيح مسلم';
                  description = 'المسند الصحيح المختصر بنقل العدل · الإمام مسلم';
                }

                final theme = Theme.of(context);
                final scheme = theme.colorScheme;
                final isDark = theme.brightness == Brightness.dark;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(
                        'hadithReading',
                        pathParameters: {'bookName': book},
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: scheme.outline,
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.25)
                                : const Color(0xFF1C443B).withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: scheme.primaryContainer,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: scheme.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Icon(
                              Icons.import_contacts_rounded,
                              color: scheme.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  arabicName,
                                  style: GoogleFonts.amiri(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: scheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: scheme.primary,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('خطأ في تحميل الكتب: $error')),
        ),
        bottomNavigationBar: const MainNavigationBar(selectedIndex: 3),
      ),
    );
  }
}
