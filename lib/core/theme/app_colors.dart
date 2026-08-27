import 'package:flutter/material.dart';

/// Midrar brand palette.
///
/// Deep pine green communicates tranquility and trust; warm paper tones keep
/// long Arabic reading sessions comfortable; muted gold is reserved for rare
/// accents (never gradients, never ornament). Dark mode is an intentional
/// night composition, not an inversion.
class AppColors {
  AppColors._();

  // ---- Light theme -------------------------------------------------------
  static const Color lightBackground = Color(0xFFF8F6F1);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF232B27);
  static const Color lightOnSurfaceVariant = Color(0xFF5C6862);
  static const Color lightAccent = Color(0xFF2F5D50); // deep pine
  static const Color lightAccentLight = Color(0xFFE4EEE9);
  static const Color lightGold = Color(0xFFB08A3E); // restrained brass
  static const Color lightError = Color(0xFFA9493C);

  // ---- Dark theme --------------------------------------------------------
  static const Color darkBackground = Color(0xFF101714);
  static const Color darkSurface = Color(0xFF18211D);
  static const Color darkOnSurface = Color(0xFFE4EAE6);
  static const Color darkOnSurfaceVariant = Color(0xFFA3B2AA);
  static const Color darkAccent = Color(0xFF8FBFA9); // soft mint
  static const Color darkAccentLight = Color(0xFF22352D);
  static const Color darkGold = Color(0xFFD8B36A);
  static const Color darkError = Color(0xFFE08A7C);

  // ---- Mushaf & reading surfaces ------------------------------------------
  /// Reading screens (mushaf, hadith, azkar) intentionally keep a constant
  /// warm-paper experience in BOTH light and dark modes — like a physical
  /// muṣḥaf. These tokens are the single source of that palette.
  static const Color mushafBackground = Color(0xFF2C241C); // reader chrome
  static const Color mushafBackgroundDeep = Color(0xFF2C1E16); // deep chrome
  static const Color mushafPaper = Color(0xFFFDF7EF); // page surface
  static const Color mushafPaperAlt = Color(0xFFF9F6EE); // text on dark chrome
  static const Color mushafPaperMuted = Color(0xFFF2E9DC); // soft paper fills
  static const Color mushafPaperEdge = Color(0xFFF0EBE1); // page outer edge
  static const Color mushafInk = Color(0xFF1C130D); // scripture text
  static const Color mushafInkStrong = Color(0xFF5A4328); // headings on paper
  static const Color mushafInkSoft = Color(0xFF8B6F4E); // subheads
  static const Color mushafInkFaint = Color(0xFF6F5A42); // meta/footers
  static const Color mushafGold = Color(0xFFC7A87D); // reading accent gold
  static const Color mushafGoldMuted = Color(0xFFB89E73); // classical frames
  static const Color mushafBorder = Color(0xFFE8DCC8); // reference boxes
  static const Color mushafBorderSoft = Color(0xFFDCD5C6); // page shadow
  static const Color mushafMarkerRed = Color(0xFF7A3E3E); // marker ribbon

  // ---- Spacing scale (4pt base) ------------------------------------------
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // ---- Radius scale --------------------------------------------------------
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
}
