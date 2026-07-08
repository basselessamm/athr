import 'package:flutter/material.dart';

class AppRadius {
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double round = 999.0;

  static BorderRadius get card => BorderRadius.circular(md);
  static BorderRadius get button => BorderRadius.circular(round);
  static BorderRadius get sheet =>
      const BorderRadius.vertical(top: Radius.circular(lg));
}
