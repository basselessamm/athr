import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Core TextThemes
  static TextTheme cairoTextTheme([TextTheme? base]) {
    return GoogleFonts.cairoTextTheme(base).copyWith(
      displayLarge: GoogleFonts.cairo(
        fontSize: 57,
        height: 1.2,
        letterSpacing: -0.25,
        textBaseline: TextBaseline.alphabetic,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 45,
        height: 1.2,
        letterSpacing: 0,
        textBaseline: TextBaseline.alphabetic,
      ),
      displaySmall: GoogleFonts.cairo(
        fontSize: 36,
        height: 1.2,
        letterSpacing: 0,
        textBaseline: TextBaseline.alphabetic,
      ),
      headlineLarge: GoogleFonts.cairo(
        fontSize: 32,
        height: 1.3,
        letterSpacing: 0,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.cairo(
        fontSize: 28,
        height: 1.3,
        letterSpacing: 0,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.cairo(
        fontSize: 24,
        height: 1.3,
        letterSpacing: 0,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.cairo(
        fontSize: 22,
        height: 1.4,
        letterSpacing: 0,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.cairo(
        fontSize: 16,
        height: 1.4,
        letterSpacing: 0.15,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.cairo(
        fontSize: 14,
        height: 1.4,
        letterSpacing: 0.1,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0.5,
        textBaseline: TextBaseline.alphabetic,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14,
        height: 1.5,
        letterSpacing: 0.25,
        textBaseline: TextBaseline.alphabetic,
      ),
      bodySmall: GoogleFonts.cairo(
        fontSize: 12,
        height: 1.5,
        letterSpacing: 0.4,
        textBaseline: TextBaseline.alphabetic,
      ),
      labelLarge: GoogleFonts.cairo(
        fontSize: 14,
        height: 1.4,
        letterSpacing: 0.1,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.cairo(
        fontSize: 12,
        height: 1.4,
        letterSpacing: 0.5,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.cairo(
        fontSize: 11,
        height: 1.4,
        letterSpacing: 0.5,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Specialized Reading TextStyles (Amiri for Quran/Hadith)
  static TextStyle readingAmiri({
    double fontSize = 24.0,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double height = 2.2, // Generous line height for Harakat clearance
  }) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static TextStyle readingAmiriBold({double fontSize = 24.0, Color? color}) {
    return readingAmiri(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }
}
