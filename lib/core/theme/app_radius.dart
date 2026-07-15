import 'package:flutter/material.dart';

class AppRadius {
  static const double sm = 8.0;   // Lists and settings
  static const double md = 12.0;  // Smaller prominent cards
  static const double lg = 16.0;  // Main prominent cards
  static const double xl = 24.0;  // Special cases (e.g. bottom sheets, modals)
  static const double xxl = 32.0; // Extra large special cases
  static const double round = 999.0;

  static BorderRadius get list => BorderRadius.circular(sm);
  static BorderRadius get card => BorderRadius.circular(lg);
  static BorderRadius get button => BorderRadius.circular(round);
  static BorderRadius get sheet =>
      const BorderRadius.vertical(top: Radius.circular(xl));
}
