import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:midrar/core/widgets/midrar_scaffold.dart';
import 'package:midrar/core/widgets/main_navigation_bar.dart';
import 'package:midrar/features/azkar/providers/azkar_providers.dart';

class AzkarCategoriesScreen extends ConsumerWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(azkarCategoriesProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MidrarScaffold(
        title: 'الأذكار',
        body: categoriesAsync.when(
          data: (categories) {
            if (categories.isEmpty) {
              return _AzkarState(
                icon: Icons.menu_book_outlined,
                title: 'لا توجد أذكار في هذا القسم الآن',
                body: 'ستظهر التصنيفات المتاحة هنا عند توفرها.',
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      20,
                      12,
                      20,
                      14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'رفيق قراءة هادئ',
                          style: GoogleFonts.amiri(
                            fontSize: 30,
                            height: 1.15,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'اختر بابًا، واقرأ الذكر على مهل. يمكنك حفظه للعودة إليه لاحقًا دون أي ضغط.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.7,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        4,
                        16,
                        8,
                      ),
                      child: Semantics(
                        button: true,
                        label: 'فتح أذكار $category',
                        child: Container(
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: scheme.outline,
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black.withValues(alpha: 0.2)
                                    : const Color(0xFF1C443B).withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => context.pushNamed(
                                'azkarReading',
                                pathParameters: {'category': category},
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
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
                                        Icons.spa_rounded,
                                        color: scheme.primary,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            category,
                                            style: GoogleFonts.amiri(
                                              fontSize: 23,
                                              height: 1.15,
                                              color: scheme.onSurface,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'قراءة هادئة قابلة للعودة',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: scheme.onSurfaceVariant,
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
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
              ],
            );
          },
          loading: () => const _AzkarState(
            icon: Icons.hourglass_top_rounded,
            title: 'يُجهّز الأذكار',
            body: 'لحظة واحدة…',
            showProgress: true,
          ),
          error: (error, stackTrace) => _AzkarState(
            icon: Icons.cloud_off_outlined,
            title: 'تعذر فتح الأذكار الآن',
            body: 'حاول العودة إلى هذه الشاشة بعد قليل.',
          ),
        ),
        bottomNavigationBar: const MainNavigationBar(selectedIndex: 2),
      ),
    );
  }
}

class _AzkarState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final bool showProgress;

  const _AzkarState({
    required this.icon,
    required this.title,
    required this.body,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: scheme.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            if (showProgress) ...[
              const SizedBox(height: 18),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: scheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
