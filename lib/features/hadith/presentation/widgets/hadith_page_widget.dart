import 'package:flutter/material.dart';

import 'package:midrar/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HadithPageWidget extends StatelessWidget {
  final int pageNumber;
  final String headerTitle;
  final String headerSubtitle;
  final String hadithText;
  final String? reference;
  final double fontSize;
  final VoidCallback? onCapturePressed;

  const HadithPageWidget({
    super.key,
    required this.pageNumber,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.hadithText,
    this.reference,
    this.fontSize = 22.0,
    this.onCapturePressed,
  });

  @override
  Widget build(BuildContext context) {
    // In Arabic, odd pages are on the right (spine on the left)
    // Even pages are on the left (spine on the right)
    final bool isRightPage = pageNumber % 2 != 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.mushafPaper, // Base paper color
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isRightPage
                  ? [
                      Colors.black.withValues(
                        alpha: 0.08,
                      ), // Spine shadow on left
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.02),
                    ]
                  : [
                      Colors.black.withValues(alpha: 0.02),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(
                        alpha: 0.08,
                      ), // Spine shadow on right
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
                  color: const Color(
                    0xFFC7A87D,
                  ), // Golden/Brownish elegant border
                  width: 2.0,
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(),
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
                              style: GoogleFonts.amiri(
                                fontSize: fontSize,
                                color: AppColors.mushafBackgroundDeep,
                                height: 1.9,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 24),
                            if (reference != null && reference!.isNotEmpty)
                              Text(
                                reference!,
                                style: GoogleFonts.amiri(
                                  fontSize: fontSize * 0.7,
                                  color: AppColors.mushafInkStrong,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.mushafGold, width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              headerSubtitle, // e.g. "كتاب الإيمان"
              style: GoogleFonts.amiri(
                color: AppColors.mushafInkStrong,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onCapturePressed,
            tooltip: 'اترك أثرًا',
            icon: const Icon(Icons.bookmark_add_outlined),
            color: AppColors.mushafInkStrong,
          ),
          Text(
            headerTitle, // e.g. "صحيح البخاري"
            style: GoogleFonts.amiri(
              color: AppColors.mushafInkStrong,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.mushafGold, width: 1.5)),
      ),
      child: Center(
        child: Text(
          _toArabicNumerals(pageNumber),
          style: GoogleFonts.amiri(
            color: AppColors.mushafInkStrong,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
