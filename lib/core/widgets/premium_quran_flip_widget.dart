import 'package:flutter/material.dart';
import 'dart:math' as math;

class PremiumQuranFlipWidget extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget endPage;
  final int initialIndex;
  final ValueChanged<int>? onPageChanged;

  const PremiumQuranFlipWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.endPage,
    this.initialIndex = 0,
    this.onPageChanged,
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
    _controller.addListener(() {
      setState(() {
        _currentPageValue = _controller.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.itemCount + 1,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        if (index == widget.itemCount) {
          return widget.endPage;
        }

        // Calculate how far this page is from the current view
        final difference = index - _currentPageValue;

        // If the page is completely out of view, don't render its heavy flip logic
        if (difference <= -1.0 || difference >= 1.0) {
          return const SizedBox.shrink(); // Lazy load optimization
        }

        // Apply 3D Matrix Transform
        // In Arabic, spine is on the Right. Rotation happens around the Right edge.
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002) // Perspective
            ..rotateY(-difference * (math.pi / 1.8)), // Angle of flip
          alignment: FractionalOffset.centerRight, // Spine is on the Right
          child: _buildPage(index, difference),
        );
      },
    );
  }

  Widget _buildPage(int index, double difference) {
    // Add page curl/shadow details dynamically based on difference
    final shadowOpacity = (difference.abs() * 0.5).clamp(0.0, 0.5);

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.itemBuilder(context, index),

        // Shadow overlay during flip
        if (difference != 0)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight, // Spine
                end: Alignment.centerLeft,
                colors: [
                  Colors.black.withValues(alpha: shadowOpacity),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.8],
              ),
            ),
          ),
      ],
    );
  }
}
