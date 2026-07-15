import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';

/// A reusable frosted glass card with backdrop blur, translucent fill and
/// subtle border — the building block of the new Glassmorphism home UI.
class AthrGlassCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = ref.watch(reduceMotionProvider);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(AppRadius.lg);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // If reduce motion is enabled, use a solid surface color instead of translucency
    final bgColor = color ?? theme.colorScheme.surface;
    final containerColor = reduceMotion
        ? bgColor
        : bgColor.withValues(alpha: isDark ? opacity : opacity + 0.15);

    final container = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: effectiveRadius,
        border: border ??
            Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: reduceMotion ? 0.05 : 0.18)
                  : (reduceMotion ? theme.colorScheme.outlineVariant : Colors.white.withValues(alpha: 0.55)),
              width: 1.5,
            ),
        boxShadow: reduceMotion
            ? [] // No shadow in reduce motion for simpler rendering
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );

    if (reduceMotion) {
      return ClipRRect(
        borderRadius: effectiveRadius,
        child: container,
      );
    }

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: container,
      ),
    );
  }
}
