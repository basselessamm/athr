import 'package:flutter/material.dart';

class ReadingThemeExtension extends ThemeExtension<ReadingThemeExtension> {
  final Color pageBackgroundColor;
  final Color pageTextureColor;
  final Color borderColor;
  final Color textColor;
  final Color bookmarkColor;
  final Color spineShadowColor;
  final Color pageEdgeHighlightColor;

  const ReadingThemeExtension({
    required this.pageBackgroundColor,
    required this.pageTextureColor,
    required this.borderColor,
    required this.textColor,
    required this.bookmarkColor,
    required this.spineShadowColor,
    required this.pageEdgeHighlightColor,
  });

  @override
  ThemeExtension<ReadingThemeExtension> copyWith({
    Color? pageBackgroundColor,
    Color? pageTextureColor,
    Color? borderColor,
    Color? textColor,
    Color? bookmarkColor,
    Color? spineShadowColor,
    Color? pageEdgeHighlightColor,
  }) {
    return ReadingThemeExtension(
      pageBackgroundColor: pageBackgroundColor ?? this.pageBackgroundColor,
      pageTextureColor: pageTextureColor ?? this.pageTextureColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      bookmarkColor: bookmarkColor ?? this.bookmarkColor,
      spineShadowColor: spineShadowColor ?? this.spineShadowColor,
      pageEdgeHighlightColor:
          pageEdgeHighlightColor ?? this.pageEdgeHighlightColor,
    );
  }

  @override
  ThemeExtension<ReadingThemeExtension> lerp(
    ThemeExtension<ReadingThemeExtension>? other,
    double t,
  ) {
    if (other is! ReadingThemeExtension) {
      return this;
    }
    return ReadingThemeExtension(
      pageBackgroundColor: Color.lerp(
        pageBackgroundColor,
        other.pageBackgroundColor,
        t,
      )!,
      pageTextureColor: Color.lerp(
        pageTextureColor,
        other.pageTextureColor,
        t,
      )!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      bookmarkColor: Color.lerp(bookmarkColor, other.bookmarkColor, t)!,
      spineShadowColor: Color.lerp(
        spineShadowColor,
        other.spineShadowColor,
        t,
      )!,
      pageEdgeHighlightColor: Color.lerp(
        pageEdgeHighlightColor,
        other.pageEdgeHighlightColor,
        t,
      )!,
    );
  }
}
