import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/reading_theme_extension.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/database/database_providers.dart';
import '../../../favorites/providers/favorites_providers.dart';

class HadithPageWidget extends ConsumerWidget {
  final int pageNumber;
  final String headerTitle;
  final String headerSubtitle;
  final String hadithText;
  final String? reference;
  final double fontSize;
  final int hadithId;
  final String bookName;

  const HadithPageWidget({
    super.key,
    required this.pageNumber,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.hadithText,
    this.reference,
    this.fontSize = 22.0,
    required this.hadithId,
    required this.bookName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In Arabic, odd pages are on the right (spine on the left)
    // Even pages are on the left (spine on the right)
    final bool isRightPage = pageNumber % 2 != 0;
    final theme = Theme.of(context);
    final readingTheme = theme.extension<ReadingThemeExtension>()!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: readingTheme.pageBackgroundColor, // Base paper color
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isRightPage
                  ? [
                      readingTheme.spineShadowColor, // Spine shadow on left
                      Colors.transparent,
                      Colors.transparent,
                      readingTheme.pageEdgeHighlightColor,
                    ]
                  : [
                      readingTheme.pageEdgeHighlightColor,
                      Colors.transparent,
                      Colors.transparent,
                      readingTheme.spineShadowColor, // Spine shadow on right
                    ],
              stops: const [0.0, 0.05, 0.95, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 32.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: readingTheme
                      .borderColor, // Golden/Brownish elegant border
                  width: 2.0,
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(theme, readingTheme),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              hadithText,
                              style: AppTypography.readingAmiri(
                                fontSize: fontSize,
                                color: readingTheme.textColor,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            if (reference != null && reference!.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Text(
                                reference!,
                                style: AppTypography.cairoTextTheme().labelSmall
                                    ?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildFooter(context, theme, readingTheme, ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ReadingThemeExtension readingTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: readingTheme.borderColor, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              headerTitle,
              style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                color: readingTheme.borderColor,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            headerSubtitle,
            style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
              color: readingTheme.borderColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme, ReadingThemeExtension readingTheme, WidgetRef ref) {
    final favoriteAsync = ref.watch(
      isFavoriteProvider((type: 'hadith', reference: hadithId.toString())),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: readingTheme.borderColor, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '$hadithText\n\n$reference'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الحديث')),
                  );
                },
                icon: Icon(Icons.copy, color: readingTheme.borderColor, size: 20),
                tooltip: 'نسخ الحديث',
              ),
              IconButton(
                onPressed: () async {
                  await ref.read(appDatabaseProvider).toggleFavorite(
                        contentType: 'hadith',
                        primaryReference: hadithId.toString(),
                        secondaryReference: bookName,
                        title: reference ?? bookName,
                        contentText: hadithText,
                        source: reference ?? bookName,
                      );
                },
                icon: favoriteAsync.when(
                  data: (isFavorite) => Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? theme.colorScheme.error : readingTheme.borderColor,
                    size: 20,
                  ),
                  loading: () => Icon(Icons.favorite_border, color: readingTheme.borderColor, size: 20),
                  error: (error, stackTrace) => Icon(Icons.favorite_border, color: readingTheme.borderColor, size: 20),
                ),
                tooltip: 'حفظ في المفضلة',
              ),
            ],
          ),
          Text(
            _toArabicNumerals(pageNumber),
            style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
              color: readingTheme.borderColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _toArabicNumerals(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = number.toString();
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }
}
