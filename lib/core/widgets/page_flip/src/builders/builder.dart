import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../effects/flip_effect.dart';

class PageFlipBuilder extends StatefulWidget {
  const PageFlipBuilder({
    super.key,
    required this.amount,
    this.backgroundColor,
    required this.child,
    required this.pageIndex,
    required this.isRightSwipe,
    required this.imageData,
    required this.currentPage,
    required this.currentWidget,
    required this.currentPageIndex,
  });

  final Animation<double> amount;
  final int pageIndex;
  final Color? backgroundColor;
  final Widget child;
  final bool isRightSwipe;

  final Map<int, ui.Image?> imageData;
  final ValueNotifier<int> currentPage;
  final ValueNotifier<Widget> currentWidget;
  final ValueNotifier<int> currentPageIndex;

  @override
  State<PageFlipBuilder> createState() => PageFlipBuilderState();
}

class PageFlipBuilderState extends State<PageFlipBuilder> {
  final _boundaryKey = GlobalKey();

  void _captureImage(Duration timeStamp, int index) async {
    if (_boundaryKey.currentContext == null) return;
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      final boundary =
          _boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = await boundary.toImage();
      setState(() {
        widget.imageData[index] = image.clone();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.currentPage,
      builder: (context, value, child) {
        if (widget.imageData[widget.pageIndex] != null && value >= 0) {
          return CustomPaint(
            painter: PageFlipEffect(
              amount: widget.amount,
              image: widget.imageData[widget.pageIndex]!,
              backgroundColor: widget.backgroundColor,
              isRightSwipe: widget.isRightSwipe,
            ),
            size: Size.infinite,
          );
        } else {
          if (value == widget.pageIndex ||
              (value == (widget.pageIndex + 1)) ||
              (value == (widget.pageIndex - 1))) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) => _captureImage(timeStamp, widget.pageIndex),
            );
          }
          if (widget.pageIndex == widget.currentPageIndex.value ||
              (widget.pageIndex == (widget.currentPageIndex.value + 1)) ||
              (widget.pageIndex == (widget.currentPageIndex.value - 1))) {
            return ColoredBox(
              color: widget.backgroundColor ?? Colors.black12,
              child: RepaintBoundary(key: _boundaryKey, child: widget.child),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }
}
