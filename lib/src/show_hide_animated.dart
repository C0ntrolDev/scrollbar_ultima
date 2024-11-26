import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrollbar_ultima/src/show_hide_animated_controller.dart';

typedef ShowHideAnimatedBuilder = Widget Function(
    BuildContext context, Animation<double> animation);

class ShowHideAnimated extends StatefulWidget {
  final ShowHideAnimatedBuilder builder;
  final ShowHideAnimatedController controller;

  final Duration animationDuration;
  final Curve animationCurve;

  const ShowHideAnimated(
      {super.key,
      required this.builder,
      required this.controller,
      required this.animationDuration,
      required this.animationCurve});

  @override
  State<ShowHideAnimated> createState() => _ShowHideAnimatedState();
}

class _ShowHideAnimatedState extends State<ShowHideAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  StreamSubscription? _isShownStreamSubscription;

  @override
  void initState() {
    super.initState();

    _createAnimations(widget.animationDuration, widget.animationCurve);
    _onThumbWithLabelControllerChanged(widget.controller);
  }

  @override
  void didUpdateWidget(covariant ShowHideAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationCurve != widget.animationCurve ||
        oldWidget.animationDuration != widget.animationDuration) {
      _createAnimations(widget.animationDuration, widget.animationCurve);
    }
    if (oldWidget.controller != widget.controller) {
      _onThumbWithLabelControllerChanged(widget.controller);
    }
  }

  @override
  void dispose() {
    _unsubscribeFromShowHideAnimatedController();

    super.dispose();
  }

  void _createAnimations(Duration duration, Curve curve) {
    _animationController = AnimationController(
      vsync: this,
      duration: duration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: curve,
    ));
  }

  void _onThumbWithLabelControllerChanged(
      ShowHideAnimatedController controller) {
    _unsubscribeFromShowHideAnimatedController();
    _subscribeToShowHideAnimatedController(controller);

    _onIsShownChanged(controller.isShown);
  }

  void _subscribeToShowHideAnimatedController(
      ShowHideAnimatedController controller) {
    _isShownStreamSubscription =
        controller.isShownStream.listen(_onIsShownChanged);
  }

  void _unsubscribeFromShowHideAnimatedController() {
    _isShownStreamSubscription?.cancel();
    _isShownStreamSubscription = null;
  }

  void _onIsShownChanged(bool newIsThumbShown) {
    if (newIsThumbShown) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, _animation);
  }
}
