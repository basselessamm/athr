import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';
import 'reading_theme_extension.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        primaryContainer: AppColors.lightAccentLight,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTypography.cairoTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.lightOnSurface),
        titleTextStyle: AppTypography.cairoTextTheme().titleLarge?.copyWith(
          color: AppColors.lightOnSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
      extensions: <ThemeExtension<dynamic>>[
        ReadingThemeExtension(
          pageBackgroundColor: const Color(0xFFF0EBE1),
          pageTextureColor: const Color(0xFFF9F6EE),
          borderColor: const Color(0xFFB89E73),
          textColor: const Color(0xFF1C130D),
          bookmarkColor: const Color(0xFF7A3E3E),
          spineShadowColor: Colors.black.withValues(alpha: 0.08),
          pageEdgeHighlightColor: Colors.white.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent,
        primaryContainer: AppColors.darkAccentLight,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.cairoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.darkOnSurface),
        titleTextStyle: AppTypography.cairoTextTheme().titleLarge?.copyWith(
          color: AppColors.darkOnSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
      extensions: <ThemeExtension<dynamic>>[
        ReadingThemeExtension(
          pageBackgroundColor: AppColors.darkBackground,
          pageTextureColor: const Color(0xFF1E1E1E),
          borderColor: const Color(0xFFB89E73).withValues(alpha: 0.5),
          textColor: const Color(0xFFE0D4C3),
          bookmarkColor: const Color(0xFF4A2525),
          spineShadowColor: Colors.black.withValues(alpha: 0.4),
          pageEdgeHighlightColor: Colors.white.withValues(alpha: 0.05),
        ),
      ],
    );
  }
}
