import 'package:flutter/material.dart';
import 'package:scrollbar_ultima/src/scrollbar_position.dart';

Widget createDeffaultThumb(
    BuildContext context,
    Animation<double> thumbAnimation,
    Set<WidgetState> widgetStates,
    Color backgroundColor,
    double thickness,
    double? length,
    ScrollbarPosition scrollbarPosition) {
  final thumbOffsetAnimation =
      Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(thumbAnimation);

  final thumbColor = Theme.of(context).scrollbarTheme.thumbColor ??
      WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.dragged) ||
            states.contains(WidgetState.pressed)) {
          return backgroundColor.withOpacity(0.6);
        }

        if (states.contains(WidgetState.hovered)) {
          return backgroundColor.withOpacity(0.5);
        }

        return backgroundColor.withOpacity(0.3);
      });

  final isVertical = scrollbarPosition == ScrollbarPosition.left ||
      scrollbarPosition == ScrollbarPosition.right;

  return SlideTransition(
      position: thumbOffsetAnimation,
      child: Align(
          alignment: Alignment.centerRight,
          child: Container(
              height: isVertical ? length : thickness,
              width: isVertical ? thickness : length,
              color: thumbColor.resolve(widgetStates))));
}

Widget createSemicircleThumb(
    {required BuildContext context,
    required Animation<double> thumbAnimation,
    required Set<WidgetState> widgetStates,
    required Color backgroundColor,
    required Color foregroundColor,
    required double elevation,
    required double crossAxisSize,
    required double mainAxisSize,
    required ScrollbarPosition scrollbarPosition}) {
  final isVertical = scrollbarPosition == ScrollbarPosition.left ||
      scrollbarPosition == ScrollbarPosition.right;

  return FadeTransition(
    opacity: thumbAnimation,
    child: Container(
      color: Colors.transparent,
      child: Material(
        elevation: elevation,
        color: backgroundColor,
        borderRadius: _getSemicircleThumbBorderRadius(
            scrollbarPosition, mainAxisSize, crossAxisSize),
        child: Container(
          constraints: BoxConstraints.tight(Size(
              isVertical ? crossAxisSize : mainAxisSize,
              isVertical ? mainAxisSize : crossAxisSize)),
          child: Padding(
            padding: _getSemicircleThumbPaintPadding(
                scrollbarPosition, mainAxisSize, crossAxisSize),
            child: RotatedBox(
              quarterTurns: isVertical ? 0 : 1,
              child: CustomPaint(
                foregroundPainter: ArrowCustomPainter(foregroundColor),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

BorderRadius _getSemicircleThumbBorderRadius(
    ScrollbarPosition scrollbarPosition,
    double mainAxisSize,
    double crossAxisSize) {
  final mainAxisRadius = Radius.circular(mainAxisSize / 2);

  Radius crossAxisRadius;
  if (mainAxisSize / 2 > crossAxisSize) {
    crossAxisRadius = Radius.zero;
  } else if (crossAxisSize > mainAxisSize) {
    crossAxisRadius = mainAxisRadius;
  } else {
    crossAxisRadius = _calculateEllipticalRadius(mainAxisSize / 2,
        crossAxisSize - (mainAxisSize / 2), scrollbarPosition);
  }

  switch (scrollbarPosition) {
    case ScrollbarPosition.top:
      return BorderRadius.only(
          bottomLeft: mainAxisRadius,
          bottomRight: mainAxisRadius,
          topLeft: crossAxisRadius,
          topRight: crossAxisRadius);
    case ScrollbarPosition.bottom:
      return BorderRadius.only(
          topLeft: mainAxisRadius,
          topRight: mainAxisRadius,
          bottomLeft: crossAxisRadius,
          bottomRight: crossAxisRadius);
    case ScrollbarPosition.right:
      return BorderRadius.only(
          bottomLeft: mainAxisRadius,
          topLeft: mainAxisRadius,
          bottomRight: crossAxisRadius,
          topRight: crossAxisRadius);
    case ScrollbarPosition.left:
      return BorderRadius.only(
          topRight: mainAxisRadius,
          bottomRight: mainAxisRadius,
          topLeft: crossAxisRadius,
          bottomLeft: crossAxisRadius);
  }
}

Radius _calculateEllipticalRadius(double maxLength, double crossAxisRadius,
    ScrollbarPosition scrollbarPosition) {
  final cos = crossAxisRadius / maxLength;
  final sin = 1 - (cos * cos);
  final mainAxisRadius = (1 - sin) * maxLength;

  final isVertical = scrollbarPosition == ScrollbarPosition.left ||
      scrollbarPosition == ScrollbarPosition.right;
  return Radius.elliptical(isVertical ? crossAxisRadius : mainAxisRadius,
      isVertical ? mainAxisRadius : crossAxisRadius);
}

EdgeInsets _getSemicircleThumbPaintPadding(ScrollbarPosition scrollbarPosition,
    double mainAxisSize, double crossAxisSize) {
  double padding = 0;
  if (crossAxisSize < mainAxisSize && crossAxisSize > mainAxisSize / 2) {
    padding = ((mainAxisSize / 2) - (crossAxisSize - (mainAxisSize / 2))) / 2;
  }

  switch (scrollbarPosition) {
    case ScrollbarPosition.top:
      return EdgeInsets.only(bottom: padding);
    case ScrollbarPosition.bottom:
      return EdgeInsets.only(top: padding);
    case ScrollbarPosition.right:
      return EdgeInsets.only(left: padding);
    case ScrollbarPosition.left:
      return EdgeInsets.only(right: padding);
  }
}

Widget createSemicircleLabel(
    {required BuildContext context,
    required Animation<double> animation,
    required Set<WidgetState> widgetStates,
    required double offset,
    required int? precalculatedIndex,
    required double thumbLength,
    required double sidePadding,
    required Color backgroundColor,
    required double elevation,
    required Widget Function(double offset, int? index) labelContentBuilder,
    required ScrollbarPosition scrollbarPosition}) {
  return FadeTransition(
      opacity: animation,
      child: Padding(
        padding: _getSemicircleLabelPadding(sidePadding, scrollbarPosition),
        child: SizedBox(
          child: Container(
            alignment: _getSemicircleLabelAlignment(scrollbarPosition),
            child: Material(
              elevation: elevation,
              color: backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(thumbLength / 2)),
              child: labelContentBuilder(offset, precalculatedIndex),
            ),
          ),
        ),
      ));
}

EdgeInsets _getSemicircleLabelPadding(
    double sidePadding, ScrollbarPosition scrollbarPosition) {
  switch (scrollbarPosition) {
    case ScrollbarPosition.top:
      return EdgeInsets.only(top: sidePadding);
    case ScrollbarPosition.bottom:
      return EdgeInsets.only(bottom: sidePadding);
    case ScrollbarPosition.right:
      return EdgeInsets.only(right: sidePadding);
    case ScrollbarPosition.left:
      return EdgeInsets.only(left: sidePadding);
  }
}

Alignment _getSemicircleLabelAlignment(ScrollbarPosition scrollBarPosition) {
  switch (scrollBarPosition) {
    case ScrollbarPosition.top:
      return Alignment.topCenter;
    case ScrollbarPosition.bottom:
      return Alignment.bottomCenter;
    case ScrollbarPosition.right:
      return Alignment.centerRight;
    case ScrollbarPosition.left:
      return Alignment.centerLeft;
  }
}

class ArrowCustomPainter extends CustomPainter {
  Color color;

  ArrowCustomPainter(this.color);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3;

    final width = size.width / 2.5;
    final height = width / 2;

    final centerY = size.height / 2;
    final centerX = size.width / 2;

    canvas.drawPath(
        _trianglePath(
            Offset(centerX - (width / 2), centerY - 2), width, height, true),
        paint);
    canvas.drawPath(
        _trianglePath(
            Offset(centerX - (width / 2), centerY + 2), width, height, false),
        paint);
  }

  static Path _trianglePath(Offset o, double width, double height, bool isUp) {
    return Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx + width, o.dy)
      ..lineTo(o.dx + (width / 2), isUp ? o.dy - height : o.dy + height)
      ..close();
  }
}
