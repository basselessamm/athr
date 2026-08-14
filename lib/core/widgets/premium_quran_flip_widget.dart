import 'dart:math' as math;

import 'package:flutter/material.dart';

class PremiumQuranFlipWidget extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget endPage;
  final int initialIndex;
  final ValueChanged<int>? onPageChanged;
  final String Function(int index, int total)? semanticPageLabel;

  const PremiumQuranFlipWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.endPage,
    this.initialIndex = 0,
    this.onPageChanged,
    this.semanticPageLabel,
  });

  @override
  State<PremiumQuranFlipWidget> createState() => _PremiumQuranFlipWidgetState();
}

class _PremiumQuranFlipWidgetState extends State<PremiumQuranFlipWidget> {
  late PageController _controller;
  double _currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPageValue = widget.initialIndex.toDouble();
    _controller = PageController(initialPage: widget.initialIndex);
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() => _currentPageValue = _controller.page ?? 0.0);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return PageView.builder(
      controller: _controller,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount: widget.itemCount + 1,
      allowImplicitScrolling: true,
      onPageChanged: (index) {
        if (index < widget.itemCount) widget.onPageChanged?.call(index);
      },
      itemBuilder: (context, index) {
        if (index == widget.itemCount) return widget.endPage;

        final difference = index - _currentPageValue;
        final child = RepaintBoundary(
          child: Semantics(
            label:
                widget.semanticPageLabel?.call(index, widget.itemCount) ??
                'الصفحة ${index + 1} من ${widget.itemCount}',
            child: widget.itemBuilder(context, index),
          ),
        );

        if (reduceMotion || difference.abs() < 0.01) return child;
        if (difference <= -1.0 || difference >= 1.0) {
          return const SizedBox.shrink();
        }

        final shadowOpacity = (difference.abs() * 0.32).clamp(0.0, 0.32);
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0016)
            ..rotateY(-difference * (math.pi / 2.15)),
          alignment: FractionalOffset.centerRight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              child,
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.black.withValues(alpha: shadowOpacity),
                        Colors.transparent,
                      ],
                      stops: const [0, 0.82],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
