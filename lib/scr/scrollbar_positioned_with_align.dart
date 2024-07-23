import 'package:flutter/material.dart';
import 'package:scrollbar_ultima/scr/scrollbar_position.dart';

class ScrollbarPositionedWithAlign extends StatelessWidget {
  final bool _isFill;
  final ScrollbarPosition position;
  final double offset;
  final Widget child;

  const ScrollbarPositionedWithAlign({super.key, required this.position, required this.offset, required this.child})
      : _isFill = false;

  const ScrollbarPositionedWithAlign.fill({super.key, required this.position, required this.child})
      : _isFill = true,
        offset = 0;

  @override
  Widget build(BuildContext context) {
    if (_isFill) {
      return Positioned.fill(
          right: position == ScrollbarPosition.left ? null : 0,
          top: position == ScrollbarPosition.bottom ? null : 0,
          bottom: position == ScrollbarPosition.top ? null : 0,
          left: position == ScrollbarPosition.right ? null : 0,
          child: Align(alignment: _getAlignment(), child: child));
    } else {
      return Positioned(
          right: _getRight(),
          left: _getLeft(),
          bottom: _getBottom(),
          top: _getTop(),
          child: Align(alignment: _getAlignment(), child: child));
    }
  }

  double? _getRight() {
    if (position == ScrollbarPosition.right) {
      return 0;
    }

    return null;
  }

  double? _getLeft() {
    if (position == ScrollbarPosition.right) {
      return null;
    }

    if (position == ScrollbarPosition.left) {
      return 0;
    }

    return offset;
  }

  double? _getBottom() {
    if (position == ScrollbarPosition.bottom) {
      return 0;
    }

    return null;
  }

  double? _getTop() {
    if (position == ScrollbarPosition.bottom) {
      return null;
    }

    if (position == ScrollbarPosition.top) {
      return 0;
    }

    return offset;
  }

  Alignment _getAlignment() {
    switch (position) {
      case ScrollbarPosition.top:
        return Alignment.topLeft;
      case ScrollbarPosition.bottom:
        return Alignment.bottomLeft;
      case ScrollbarPosition.right:
        return Alignment.topRight;
      case ScrollbarPosition.left:
        return Alignment.topLeft;
    }
  }
}
