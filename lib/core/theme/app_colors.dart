import 'package:flutter/material.dart';

/// Midrar & ATHR bespoke brand palette.
///
/// Crafted specifically around Andalusian manuscripts, natural warm linen,
/// burnished brass accents, and serene night oasis tones.
/// Free of generic defaults, high-contrast harshness, or superficial gamification.
class AppColors {
  AppColors._();

  // ---- Light theme (Luminous Andalusian Linen) ---------------------------
  static const Color lightBackground = Color(0xFFF9F6F0); // warm alabaster linen
  static const Color lightSurface = Color(0xFFFFFFFF); // crisp clean card
  static const Color lightSurfaceSubtle = Color(0xFFF3ECE0); // warm parchment fill
  static const Color lightOnSurface = Color(0xFF17231E); // deep walnut-pine ink
  static const Color lightOnSurfaceVariant = Color(0xFF566860); // olive muted gray
  static const Color lightAccent = Color(0xFF1C443B); // Andalusian deep emerald
  static const Color lightAccentLight = Color(0xFFE2EDE8); // silken mint frost
  static const Color lightGold = Color(0xFFC59B3F); // burnished antique gold
  static const Color lightGoldLight = Color(0xFFFBF4E4); // warm gold tint
  static const Color lightError = Color(0xFFA33B2E); // muted terracotta
  static const Color lightBorder = Color(0xFFEADBCC); // warm linen border

  // ---- Dark theme (Midnight Oasis & Obsidian Olive) ----------------------
  static const Color darkBackground = Color(0xFF0D1613); // deep oasis obsidian
  static const Color darkSurface = Color(0xFF14221D); // deep palm canopy
  static const Color darkSurfaceSubtle = Color(0xFF1A2B25); // elevated night surface
  static const Color darkOnSurface = Color(0xFFEAF2ED); // alabaster silk
  static const Color darkOnSurfaceVariant = Color(0xFF9EAEA5); // muted sage mist
  static const Color darkAccent = Color(0xFF7EBF9E); // silken sage leaf
  static const Color darkAccentLight = Color(0xFF1D352B); // deep pine shadow
  static const Color darkGold = Color(0xFFE2BE6C); // sidr amber star
  static const Color darkGoldLight = Color(0xFF332912); // deep amber tint
  static const Color darkError = Color(0xFFE5877A);
  static const Color darkBorder = Color(0xFF20332B); // subtle oasis border

  // ---- Emotional & Situational Nuance Palette -----------------------------
  static const Color emotionTranquility = Color(0xFF2A6F68); // فيروزي السكينة
  static const Color emotionHope = Color(0xFF2D5377); // أزرق الرجاء
  static const Color emotionGratitude = Color(0xFFA87B28); // عنبر الشكر
  static const Color emotionComfort = Color(0xFF915042); // تيراكوتا الاحتواء
  static const Color emotionReflection = Color(0xFF5F4B73); // خزامى التفكر

  // ---- Mushaf & reading surfaces ------------------------------------------
  /// Reading screens (mushaf, hadith, azkar) maintain a constant
  /// warm-parchment tactile experience in both modes — like holding a physical muṣḥaf.
  static const Color mushafBackground = Color(0xFF241A12); // deep heritage leather chrome
  static const Color mushafBackgroundDeep = Color(0xFF1C130B); // deep leather chrome
  static const Color mushafPaper = Color(0xFFFAF3E7); // warm Andalusian parchment
  static const Color mushafPaperAlt = Color(0xFFF6EFE1); // text on dark chrome
  static const Color mushafPaperMuted = Color(0xFFEFE4D2); // soft paper fills
  static const Color mushafPaperEdge = Color(0xFFE6D8C2); // page outer edge
  static const Color mushafInk = Color(0xFF18110A); // carbon-nutgall scripture ink
  static const Color mushafInkStrong = Color(0xFF523B22); // headings on paper
  static const Color mushafInkSoft = Color(0xFF806240); // subheads
  static const Color mushafInkFaint = Color(0xFF675039); // meta/footers
  static const Color mushafGold = Color(0xFFBD964D); // illuminated gold
  static const Color mushafGoldMuted = Color(0xFFA98540); // classical frames
  static const Color mushafBorder = Color(0xFFE2D2B8); // reference boxes
  static const Color mushafBorderSoft = Color(0xFFD4C3A6); // page shadow
  static const Color mushafMarkerRed = Color(0xFF7E3535); // crimson bookmark ribbon

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
