import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:athr/core/theme/app_radius.dart';

/// A reusable frosted glass card with backdrop blur, translucent fill and
/// subtle border — the building block of the new Glassmorphism home UI.
class AthrGlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BoxBorder? border;

  const AthrGlassCard({
    super.key,
    required this.child,
    this.blur = 30.0,
    this.opacity = 0.10,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16.0),
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(AppRadius.lg);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = color ?? theme.colorScheme.surface;

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: isDark ? opacity : opacity + 0.15),
            borderRadius: effectiveRadius,
            border: border ??
                Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.18)
                      : Colors.white.withValues(alpha: 0.55),
                  width: 1.5,
                ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
