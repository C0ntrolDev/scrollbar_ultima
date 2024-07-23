import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:scrollbar_ultima/scr/elements_behaviours.dart';
import 'package:scrollbar_ultima/scr/material_state_builder.dart';
import 'package:scrollbar_ultima/scr/scrollbar_position.dart';
import 'package:scrollbar_ultima/scr/scrollbar_positioned_with_align.dart';
import 'package:scrollbar_ultima/scr/scrollbars_builders.dart';
import 'package:scrollbar_ultima/scr/show_hide_animated.dart';
import 'package:scrollbar_ultima/scr/show_hide_animated_controller.dart';

/// A powerful Scrollbar that allows you to customize everything to your needs!
class ScrollbarUltima extends StatefulWidget {
  /// Any widget
  final Widget child;

  /// Used to get and modify scroll information
  ///
  /// By default, [PrimaryScrollController].of(context) is used
  final ScrollController? controller;

  late final Widget Function(BuildContext context, Animation<double> animation, Set<WidgetState> widgetStates)
      _thumbBuilder;
  Widget Function(BuildContext context, Animation<double> animation, Set<WidgetState> widgetStates) get thumbBuilder =>
      _thumbBuilder;

  /// Custom builder for the Track. `animation` indicates how much the Track is currently shown/hidden. `widgetStates` represents the current state of the Thumb, which can be pressed, dragged, or hovered (PC only)
  final Widget Function(BuildContext context, Animation<double> animation, Set<WidgetState> widgetStates)?
      trackBuilder;

  late final Widget Function(BuildContext context, Animation<double> animation, Set<WidgetState> widgetStates,
      double offset, int? precalculatedIndex)? _labelBuilder;
  Widget Function(BuildContext context, Animation<double> animation, Set<WidgetState> widgetStates, double offset,
      int? precalculatedIndex)? get labelBuilder => _labelBuilder;

  /// The position of ScrollbarUltima on the screen
  final ScrollbarPosition scrollbarPosition;

  /// Padding for the entire Scrollbar (Thumb, Label, Track)
  final EdgeInsets scrollbarPadding;

  /// Animation curve for showing and hiding
  final Curve animationCurve;

  /// Duration of the animation for showing and hiding
  final Duration animationDuration;

  /// The duration before the Thumb hides
  final Duration durationBeforeHide;

  /// Length of the Scrollbar. By default, it occupies all available space
  final double? scrollbarLength;

  /// The offset from which the Thumb starts moving, and the minimum offset to which it can be dragged
  ///
  /// Can be used in [CustomScrollView] with [SliverAppBar], so the Thumb starts moving only after the AppBar is out of the user's view. An example can be seen in customized_example
  final double? minScrollOffset;

  /// The maximum offset to which the Thumb continues to move, and the maximum offset to which it can be dragged
  final double? maxScrollOffset;

  /// Same as [maxScrollOffset], but allows specifying it from the end
  ///
  /// Calculated as: scrollController.position.maxScrollExtent - [maxScrollOfssetFromEnd]
  final double? maxScrollOfssetFromEnd;

  /// Should the Thumb automatically hide when the user scrolls beyond [minScrollOffset] or [maxScrollOffset]
  final bool hideThumbWhenOutOfOffset;

  /// Should the Thumb always be shown
  final bool alwaysShowThumb;

  /// Сan the Thumb be dragged
  final bool isDraggable;

  /// Should the Thumb length depend on the available scroll area and screen size
  final bool dynamicThumbLength;

  /// Minimum length of the Thumb. Useful when the scrollable area is too large, making the Thumb too small
  ///
  /// Also used as the default height for the Thumb
  final double? minDynamicThumbLength;

  /// Maximum length of the Thumb
  final double? maxDynamicThumbLength;

  /// When the Label should be shown or hidden
  final LabelBehaviour labelBehaviour;

  /// Should Label be center by the Thumb.
  ///
  /// Due to calculation specifics, the Label length lags by 1 frame, so frequent and sharp changes in its length are not recommended (small length changes are almost unnoticeable). Otherwise, the Label may shift slightly to the side
  final bool centerLabelByThumb;

  /// The offset of the top edge of the Label relative to the top edge of the Thumb, used only if [centerLabelByThumb] == false
  final double labelOffset;

  /// When the Track should be shown or hidden
  final TrackBehavior trackBehavior;

  /// Should the Thumb move to the click position on the Track
  ///
  /// This behavior is often expected by PC users. For its use, [trackBuilder] must be specified
  final bool moveThumbOnTrackClick;

  /// Special scroll mode. Performs non-linear scrolling, jumping between elements
  ///
  /// This can be very useful in large lists where lags during Thumb movement are inevitable, as items will replace each other in fixed positions, and the lags will not be visible
  final bool isFixedScroll;

  /// Extend of item. Needed for [precalculateItemByOffset] and [isFixedScroll]. Alternative - [prototypeItem]
  final double? itemExtend;

  /// Allows calculating [itemExtend] based on the length of the given widget. Needed for [precalculateItemByOffset] and [isFixedScroll]. Alternative - [itemExtend]
  final Widget? prototypeItem;

  /// Should the item index pre-calculate for display or use in labelBuilder
  ///
  /// Usage can be seen in customized_example
  final bool precalculateItemByOffset;

  /// Offset for pre-calculating the item index.
  ///
  /// Pre-calculation occurs independently of [minScrollOffset], so often the offset will be equal to [minScrollOffset]
  final double itemPrecalculationOffset;

  /// Background color for Label and Thumb surfaces
  final Color backgroundColor;

  /// Creates the default Thumb without a Label, but also allows specifying their builders
  ///
  /// [thumbBuilder] allows specifying a custom builder for the Thumb. `animation` indicates how much the Thumb is currently shown/hidden. `widgetStates` represents the current state of the Thumb, which can be pressed, dragged, or hovered (PC only).
  /// 
  /// [labelBuilder] allows specifying a custom builder for the Label. `animation` indicates how much the Label is currently shown/hidden. `widgetStates` represents the current state of the Thumb, which can be pressed, dragged, or hovered (PC only). `offset` is the offset of the scrollController. `precalculatedIndex` is not null only if [precalculateItemByOffset] is true, and indicates the estimated index of the current item. If the scroll is beyond [minScrollOffset], it equals -1.
  ScrollbarUltima(
      {super.key,
      required this.child,
      Widget Function(BuildContext context, Animation<double> animation, Set<WidgetState> widgetStates)? thumbBuilder,
      this.backgroundColor = Colors.black,
      double defaultThumbThickness = 10,
      Widget Function(BuildContext context, Animation<double> animation, Set<WidgetState> widgetStates, double offset,
              int? precalculatedIndex)?
          labelBuilder,
      this.trackBuilder,
      this.controller,
      this.scrollbarPadding = const EdgeInsets.all(0),
      this.scrollbarPosition = ScrollbarPosition.right,
      this.animationCurve = Curves.easeInOut,
      this.animationDuration = const Duration(milliseconds: 500),
      this.durationBeforeHide = const Duration(seconds: 1),
      this.scrollbarLength,
      this.minScrollOffset,
      this.maxScrollOfssetFromEnd,
      this.maxScrollOffset,
      this.hideThumbWhenOutOfOffset = false,
      this.alwaysShowThumb = true,
      this.isDraggable = true,
      this.dynamicThumbLength = true,
      this.maxDynamicThumbLength,
      this.minDynamicThumbLength,
      this.labelBehaviour = LabelBehaviour.showOnlyWhileDragging,
      this.labelOffset = 0,
      this.centerLabelByThumb = true,
      this.trackBehavior = TrackBehavior.alwaysShow,
      this.moveThumbOnTrackClick = false,
      this.prototypeItem,
      this.itemExtend,
      this.precalculateItemByOffset = false,
      this.isFixedScroll = false,
      this.itemPrecalculationOffset = 0}) {
    _labelBuilder = labelBuilder;
    _thumbBuilder = thumbBuilder ??
        (context, thumbAnimation, widgetStates) => createDeffaultThumb(context, thumbAnimation, widgetStates,
            backgroundColor, defaultThumbThickness, minDynamicThumbLength, scrollbarPosition);
    checkAsserts();
  }

  /// Creates a Semicircle Thumb with a rounded Label. You can specify a builder for the Label content
  ///
  /// Similar to the one in DraggableScrollbar
  /// 
  /// [labelContentBuilder] - builder for the label content. `offset` is the offset of the scrollController. `precalculatedIndex` is not null only if [precalculateItemByOffset] is true, and indicates the estimated index of the current item. If the scroll is beyond [minScrollOffset], it equals -1.
  /// 
  /// [thumbMainAxisSize] - length of the Thumb
  /// [thumbCrossAxisSize] - thickness of the Thumb
  /// [labelSidePadding] - distance between the Label and the screen edge to which the Scrollbar is attached
  /// [elevation] - shadow for the Thumb and Label
  /// [arrowsColor] - color of the icon on the Thumb
  ScrollbarUltima.semicircle(
      {super.key,
      required this.child,
      this.controller,
      Widget Function(double offset, int? precalculatedIndex)? labelContentBuilder,
      double thumbMainAxisSize = 48,
      double thumbCrossAxisSize = 48 / 6 * 5,
      double labelSidePadding = 20,
      double elevation = 4,
      Color arrowsColor = Colors.grey,
      this.backgroundColor = Colors.white,
      this.scrollbarPadding = const EdgeInsets.all(0),
      this.animationCurve = Curves.easeInOut,
      this.animationDuration = const Duration(milliseconds: 500),
      this.durationBeforeHide = const Duration(seconds: 1),
      this.scrollbarPosition = ScrollbarPosition.right,
      this.scrollbarLength,
      this.minScrollOffset,
      this.maxScrollOffset,
      this.maxScrollOfssetFromEnd,
      this.hideThumbWhenOutOfOffset = false,
      this.alwaysShowThumb = true,
      this.isDraggable = true,
      this.labelBehaviour = LabelBehaviour.showOnlyWhileDragging,
      this.labelOffset = 0,
      this.centerLabelByThumb = true,
      this.prototypeItem,
      this.itemExtend,
      this.precalculateItemByOffset = false,
      this.isFixedScroll = false,
      this.itemPrecalculationOffset = 0})
      : trackBuilder = null,
        moveThumbOnTrackClick = false,
        dynamicThumbLength = false,
        minDynamicThumbLength = null,
        maxDynamicThumbLength = null,
        trackBehavior = TrackBehavior.alwaysShow {
    _thumbBuilder = (context, thumbAnimation, widgetStates) => createSemicircleThumb(
        context: context,
        thumbAnimation: thumbAnimation,
        widgetStates: widgetStates,
        backgroundColor: backgroundColor,
        foregroundColor: arrowsColor,
        elevation: elevation,
        mainAxisSize: thumbMainAxisSize,
        crossAxisSize: thumbCrossAxisSize,
        scrollbarPosition: scrollbarPosition);

    if (labelContentBuilder == null) {
      _labelBuilder = null;
    } else {
      _labelBuilder = (context, labelAnimation, widgetStates, offset, index) => createSemicircleLabel(
          context: context,
          animation: labelAnimation,
          widgetStates: widgetStates,
          offset: offset,
          precalculatedIndex: index,
          backgroundColor: backgroundColor,
          elevation: elevation,
          thumbLength: thumbMainAxisSize,
          labelContentBuilder: labelContentBuilder,
          sidePadding: thumbCrossAxisSize + labelSidePadding,
          scrollbarPosition: scrollbarPosition);
    }

    checkAsserts();
  }

  void checkAsserts() {
    assert(((!(itemExtend != null && prototypeItem != null))), 'You must set only prototypeItem or itemExtend');
    assert((maxScrollOffset != null && maxScrollOfssetFromEnd == null) || maxScrollOffset == null,
        'You must set only maxScrollOffset or maxScrollOffsetFromEnd');
    assert(
        ((maxScrollOffset != null && minScrollOffset != null && maxScrollOffset! > minScrollOffset!) ||
            maxScrollOffset == null ||
            minScrollOffset == null),
        'maxScrollOffset must be larger than minScrollOffset');
    assert(!isFixedScroll || ((itemExtend != null || prototypeItem != null)),
        'If you want to use fixedScroll, you must set prototypeItem or itemExtend');
    assert(!precalculateItemByOffset || ((itemExtend != null || prototypeItem != null)),
        'If you want to use precalculateItemByOffset, you must set prototypeItem or itemExtend');
  }

  @override
  ScrollbarUltimaState createState() => ScrollbarUltimaState();
}

class ScrollbarUltimaState extends State<ScrollbarUltima> with TickerProviderStateMixin {
  ScrollController? _scrollController;

  bool get isVerticalScroll =>
      widget.scrollbarPosition == ScrollbarPosition.right || widget.scrollbarPosition == ScrollbarPosition.left;

  bool _isScrollOffsetOutOfRange = true;

  double get _minScrollOffset => widget.minScrollOffset ?? 0;
  double? get _maxScrollOffset => (widget.maxScrollOffset ??
      (_scrollController != null
          ? _scrollController!.position.maxScrollExtent - (widget.maxScrollOfssetFromEnd ?? 0)
          : null));

  double _scrollbarZoneLength = 0;

  double _thumbLength = 0;
  double get _thumbScrollRange => max((widget.scrollbarLength ?? _scrollbarZoneLength) - _thumbLength, 0);

  double _labelLength = 0;
  double get _labelScrollRange => max((widget.scrollbarLength ?? _scrollbarZoneLength) - _labelLength, 0);

  final GlobalKey _prototypeItemKey = GlobalKey();
  double? _fixedItemLength;

  double _actualScrollViewOffsetField = 0;
  double get _actualScrollViewOffset => _actualScrollViewOffsetField;
  set _actualScrollViewOffset(double newValue) {
    _actualScrollViewOffsetField = newValue;
    _onActualScrollViewOffsetChanged(newValue);
    _actualScrollViewOffsetStreamController.add(newValue);
  }

  late final ShowHideAnimatedController _thumbController;
  late final ShowHideAnimatedController _labelController;
  late final ShowHideAnimatedController _trackController;

  StreamSubscription<bool>? _thumbIsShownSubscription;
  bool _isThumbDraggedBeforeHide = false;
  bool _isDragging = false;

  final StreamController<double> _actualScrollViewOffsetStreamController = StreamController.broadcast();

  @override
  void initState() {
    super.initState();

    _thumbController = ShowHideAnimatedController(
        mustBeHidden: _thumbMustBeHidden, durationBeforePlannedHidding: widget.durationBeforeHide);
    _labelController = ShowHideAnimatedController(
        mustBeHidden: _labelMustBeHidden, durationBeforePlannedHidding: widget.durationBeforeHide);
    _trackController = ShowHideAnimatedController(
        mustBeHidden: _trackMustBeHidden, durationBeforePlannedHidding: widget.durationBeforeHide);

    _thumbIsShownSubscription = _thumbController.isShownStream.listen(_onThumbShownChanged);

    _updateScrollController();
    _updatePrototypeLength();

    if (widget.alwaysShowThumb) {
      _maybeUpdateControllers();
    }
  }

  @override
  void didUpdateWidget(ScrollbarUltima oldWidget) {
    super.didUpdateWidget(oldWidget);

    _isThumbDraggedBeforeHide = false;

    _updateScrollController();
    _updatePrototypeLength();

    if (widget.alwaysShowThumb) {
      _maybeUpdateControllers();
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _thumbIsShownSubscription?.cancel();
    _thumbController.dispose();
    _labelController.dispose();
    _trackController.dispose();
    super.dispose();
  }

  void _maybeUpdateControllers() {
    _thumbController.maybeUpdate();
    _labelController.maybeUpdate();
    _trackController.maybeUpdate();
  }

  void _maybeScheduleControllersUpdate() {
    _thumbController.maybeScheduleUpdate();
    _labelController.maybeScheduleUpdate();
    _trackController.maybeScheduleUpdate();
  }

  void _updateScrollController() {
    if (_scrollController != null) {
      _scrollController!.removeListener(_onScroll);
      _scrollController!.position.isScrollingNotifier.removeListener(_onScrollStatusChanged);
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController = widget.controller ?? PrimaryScrollController.of(context);
      _scrollController!.addListener(_onScroll);

      assert(_scrollController!.positions.isNotEmpty,
          'The ScrollController is not attached to any scroll views. This may happen for several reasons, including: you did not set the ScrollController in any ScrollViews, or if you are using Windows and did not set the ScrollController in your ScrollView, you need to set the primary field in your ScrollView to true. https://docs.flutter.dev/release/breaking-changes/primary-scroll-controller-desktop');
      _scrollController!.position.isScrollingNotifier.addListener(_onScrollStatusChanged);

      setState(() {});
    });
  }

  void _updatePrototypeLength() {
    if (widget.itemExtend != null) {
      _fixedItemLength = widget.itemExtend;
    } else {
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        final renderBoxSize = (_prototypeItemKey.currentContext?.findRenderObject() as RenderBox?)?.size;
        _fixedItemLength = isVerticalScroll ? renderBoxSize?.height : renderBoxSize?.width;
      });
    }
  }

  void _onScroll() {
    if (!_isDragging) {
      _actualScrollViewOffset = _scrollController!.offset;
    }
  }

  void _onThumbShownChanged(bool isShown) {
    if (!isShown) {
      _isThumbDraggedBeforeHide = false;
    }
  }

  void _onActualScrollViewOffsetChanged(double newActualScrollViewOffset) {
    if (!isScrollbarInValidState()) return;

    final relativeScrollbarOffset = newActualScrollViewOffset - _minScrollOffset;
    _isScrollOffsetOutOfRange = relativeScrollbarOffset < 0 || relativeScrollbarOffset > _maxScrollOffset!;

    _maybeUpdateControllers();
  }

  void _onScrollStatusChanged() {
    _maybeScheduleControllersUpdate();
  }

  bool _thumbMustBeHidden() =>
      !widget.alwaysShowThumb &&
      (!isScrollbarInValidState() ||
          ((_isScrollOffsetOutOfRange && widget.hideThumbWhenOutOfOffset) ||
              (!_scrollController!.position.isScrollingNotifier.value && !_isDragging)));
  bool _labelMustBeHidden() =>
      _thumbMustBeHidden() ||
      (widget.labelBehaviour == LabelBehaviour.showOnlyWhileDragging && !_isDragging) ||
      (widget.labelBehaviour == LabelBehaviour.showOnlyWhileAndAfterDragging && !_isThumbDraggedBeforeHide);

  bool _trackMustBeHidden() {
    if (widget.trackBehavior == TrackBehavior.alwaysShow) {
      return false;
    }

    if (widget.trackBehavior == TrackBehavior.showWhenThumbNotShown) {
      return !_thumbMustBeHidden();
    }

    return _thumbMustBeHidden() || (widget.trackBehavior == TrackBehavior.showOnlyWhileDragging && !_isDragging);
  }

  bool isScrollbarInValidState() {
    if (_maxScrollOffset == null) return false;

    final scrollbarScrollRange = _maxScrollOffset! - _minScrollOffset;
    if (scrollbarScrollRange <= 0) return false;

    if (_thumbScrollRange <= 0) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(child: widget.child),
        MaterialStateBuilder(builder: (context, materialStates, addMaterialState, removeMaterialState) {
          return StreamBuilder(
              initialData: 0,
              stream: _actualScrollViewOffsetStreamController.stream,
              builder: (context, _) {
                return Padding(
                  padding: widget.scrollbarPadding,
                  child: LayoutBuilder(builder: (context, constraints) {
                    var constraintsMaxLength = isVerticalScroll ? constraints.maxHeight : constraints.maxWidth;
                    if (_scrollbarZoneLength != constraintsMaxLength) {
                      _scrollbarZoneLength = constraintsMaxLength;
                      _maybeUpdateControllers();
                    }

                    return SizedBox(
                      height: isVerticalScroll ? widget.scrollbarLength : null,
                      width: !isVerticalScroll ? widget.scrollbarLength : null,
                      child: Stack(
                        children: [
                          if (widget.trackBuilder != null)
                            ScrollbarPositionedWithAlign.fill(
                                position: widget.scrollbarPosition,
                                child: RepaintBoundary(child: Builder(builder: (context) {
                                  final showHideAnimated = ShowHideAnimated(
                                      controller: _trackController,
                                      animationDuration: widget.animationDuration,
                                      animationCurve: widget.animationCurve,
                                      builder: (context, animation) =>
                                          widget.trackBuilder!(context, animation, materialStates));

                                  if (widget.moveThumbOnTrackClick && _trackController.isShown) {
                                    return GestureDetector(
                                      onTapUp: (details) {
                                        _isDragging = true;
                                        _onTrackTappedOrDragged(details.localPosition);
                                      },
                                      onTapCancel: () {
                                        _isDragging = false;
                                        _maybeScheduleControllersUpdate();
                                      },
                                      onVerticalDragStart: (details) {
                                        if (isVerticalScroll) {
                                          _isDragging = true;
                                          _onTrackTappedOrDragged(details.localPosition);
                                        }
                                      },
                                      onVerticalDragUpdate: (details) {
                                        if (isVerticalScroll) {
                                          _onTrackTappedOrDragged(details.localPosition);
                                        }
                                      },
                                      onVerticalDragCancel: () {
                                        if (isVerticalScroll) {
                                          _isDragging = false;
                                          _maybeScheduleControllersUpdate();
                                        }
                                      },
                                      onVerticalDragEnd: (details) {
                                        if (isVerticalScroll) {
                                          _isDragging = false;
                                          _maybeScheduleControllersUpdate();
                                        }
                                      },
                                      onHorizontalDragStart: (details) {
                                        if (!isVerticalScroll) {
                                          _isDragging = true;
                                          _onTrackTappedOrDragged(details.localPosition);
                                        }
                                      },
                                      onHorizontalDragUpdate: (details) {
                                        if (!isVerticalScroll) {
                                          _onTrackTappedOrDragged(details.localPosition);
                                        }
                                      },
                                      onHorizontalDragCancel: () {
                                        if (!isVerticalScroll) {
                                          _isDragging = false;
                                          _maybeScheduleControllersUpdate();
                                        }
                                      },
                                      onHorizontalDragEnd: (details) {
                                        if (!isVerticalScroll) {
                                          _isDragging = false;
                                          _maybeScheduleControllersUpdate();
                                        }
                                      },
                                      child: showHideAnimated,
                                    );
                                  }

                                  return showHideAnimated;
                                }))),
                          if (widget.labelBuilder != null)
                            ScrollbarPositionedWithAlign(
                                position: widget.scrollbarPosition,
                                offset: _calculateLabelOffset() ?? 0,
                                child: RepaintBoundary(
                                    child: ShowHideAnimated(
                                        controller: _labelController,
                                        animationCurve: widget.animationCurve,
                                        animationDuration: widget.animationDuration,
                                        builder: (context, animation) => Builder(builder: (context) {
                                              _scheduleContextLengthCheck(context, (newLabelLength) {
                                                if (newLabelLength != _labelLength) {
                                                  _labelLength = newLabelLength ?? 0;
                                                }
                                              });

                                              return widget.labelBuilder!(context, animation, materialStates,
                                                  _actualScrollViewOffset, _precalculateIndex());
                                            })))),
                          ScrollbarPositionedWithAlign(
                              position: widget.scrollbarPosition,
                              offset: _calculateThumbOffset() ?? 0,
                              child: RepaintBoundary(
                                  child: ShowHideAnimated(
                                controller: _thumbController,
                                animationCurve: widget.animationCurve,
                                animationDuration: widget.animationDuration,
                                builder: (context, animation) => Builder(builder: (context) {
                                  final thumb = Builder(builder: (context) {
                                    _scheduleContextLengthCheck(context, (newThumbLength) {
                                      if (newThumbLength != _thumbLength) {
                                        _thumbLength = newThumbLength ?? 0;
                                      }
                                    });

                                    final double? dynamicLength = widget.dynamicThumbLength
                                        ? (calculateDynamicThumbLength() ?? 0).clamp(widget.minDynamicThumbLength ?? 0,
                                            widget.maxDynamicThumbLength ?? double.infinity)
                                        : null;

                                    return SizedBox(
                                        height: isVerticalScroll ? dynamicLength : null,
                                        width: !isVerticalScroll ? dynamicLength : null,
                                        child: widget.thumbBuilder(context, animation, materialStates));
                                  });

                                  if (!widget.isDraggable || !_thumbController.isShown) {
                                    return IgnorePointer(child: thumb);
                                  }

                                  return GestureDetector(
                                    onTapDown: (details) {
                                      addMaterialState(WidgetState.pressed);
                                    },
                                    onTapUp: (details) {
                                      removeMaterialState(WidgetState.pressed);
                                    },
                                    onTapCancel: () {
                                      removeMaterialState(WidgetState.pressed);
                                    },
                                    onVerticalDragStart: (details) {
                                      if (isVerticalScroll) {
                                        addMaterialState(WidgetState.dragged);

                                        _isDragging = true;
                                        _isThumbDraggedBeforeHide = true;
                                      }
                                    },
                                    onVerticalDragUpdate: (details) {
                                      if (isVerticalScroll) {
                                        _onThumbDragged(details);
                                      }
                                    },
                                    onVerticalDragEnd: (details) {
                                      if (isVerticalScroll) {
                                        removeMaterialState(WidgetState.dragged);

                                        _isDragging = false;
                                        _maybeScheduleControllersUpdate();
                                      }
                                    },
                                    onVerticalDragCancel: () {
                                      if (isVerticalScroll) {
                                        removeMaterialState(WidgetState.dragged);

                                        _isDragging = false;
                                        _maybeScheduleControllersUpdate();
                                      }
                                    },
                                    onHorizontalDragStart: (details) {
                                      if (!isVerticalScroll) {
                                        addMaterialState(WidgetState.dragged);

                                        _isDragging = true;
                                        _isThumbDraggedBeforeHide = true;
                                      }
                                    },
                                    onHorizontalDragUpdate: (details) {
                                      if (!isVerticalScroll) {
                                        _onThumbDragged(details);
                                      }
                                    },
                                    onHorizontalDragEnd: (details) {
                                      if (!isVerticalScroll) {
                                        removeMaterialState(WidgetState.dragged);

                                        _isDragging = false;
                                        _maybeScheduleControllersUpdate();
                                      }
                                    },
                                    onHorizontalDragCancel: () {
                                      if (!isVerticalScroll) {
                                        removeMaterialState(WidgetState.dragged);

                                        _isDragging = false;
                                        _maybeScheduleControllersUpdate();
                                      }
                                    },
                                    child: Builder(builder: (context) {
                                      if (defaultTargetPlatform == TargetPlatform.android ||
                                          defaultTargetPlatform == TargetPlatform.iOS) {
                                        return thumb;
                                      }

                                      return MouseRegion(
                                          onHover: (_) => addMaterialState(WidgetState.hovered),
                                          onExit: (_) => removeMaterialState(WidgetState.hovered),
                                          child: thumb);
                                    }),
                                  );
                                }),
                              ))),
                        ],
                      ),
                    );
                  }),
                );
              });
        }),
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Container(
                key: _prototypeItemKey,
                child: widget.prototypeItem ?? Container(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _scheduleContextLengthCheck(BuildContext? context, void Function(double?) onGot) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      var newLength = isVerticalScroll ? context?.size?.height : context?.size?.width;
      onGot.call(newLength);
    });
  }

  double? _calculateThumbOffset() {
    if (!isScrollbarInValidState()) return null;
    final scrollbarScrollRange = _maxScrollOffset! - _minScrollOffset;

    final relativeScrollbarOffset = _actualScrollViewOffset - _minScrollOffset;
    final double thumbOffset =
        (relativeScrollbarOffset / scrollbarScrollRange * _thumbScrollRange).clamp(0, _thumbScrollRange);
    return thumbOffset;
  }

  double? _calculateLabelOffset() {
    if (!isScrollbarInValidState()) return null;

    final thumbOffset = _calculateThumbOffset();
    if (thumbOffset == null) return null;

    double labelOffset;
    if (widget.centerLabelByThumb) {
      final thumbCenterOffset = thumbOffset + (_thumbLength / 2);
      labelOffset = (thumbCenterOffset - (_labelLength / 2));
    } else {
      labelOffset = thumbOffset + widget.labelOffset;
    }

    return labelOffset.clamp(0, _labelScrollRange);
  }

  double? calculateDynamicThumbLength() {
    if (!isScrollbarInValidState()) return null;

    final scrollbarScrollRange = _maxScrollOffset! - _minScrollOffset;
    final screenLengthToScrollRange = _scrollController!.position.viewportDimension / scrollbarScrollRange;
    return screenLengthToScrollRange * _scrollbarZoneLength;
  }

  int? _precalculateIndex() {
    if (widget.precalculateItemByOffset && _fixedItemLength != null) {
      if (_actualScrollViewOffset < widget.itemPrecalculationOffset) {
        return -1;
      }

      return ((_actualScrollViewOffset - widget.itemPrecalculationOffset) / _fixedItemLength!).round();
    }

    return null;
  }

  void _onThumbDragged(DragUpdateDetails details) {
    final newOffset = _addDragDeltaToOffset(
        oldOffset: _actualScrollViewOffset, dragDelta: details.primaryDelta!, thumbScrollRange: _thumbScrollRange);
    _actualScrollViewOffset = newOffset;

    moveScrollViewToOffset(newOffset);
  }

  double _addDragDeltaToOffset(
      {required double oldOffset, required double dragDelta, required double thumbScrollRange}) {
    final absoluteDelta = dragDelta / thumbScrollRange;
    oldOffset = max(_minScrollOffset, oldOffset);
    double newOffset = (oldOffset + (absoluteDelta * (_maxScrollOffset! - _minScrollOffset)))
        .clamp(_minScrollOffset, _maxScrollOffset!);
    return newOffset;
  }

  void _onTrackTappedOrDragged(Offset position) {
    final absoluteY = ((isVerticalScroll ? position.dy : position.dx) / _thumbScrollRange).clamp(0, 1);
    final newOffset = (((_maxScrollOffset! - _minScrollOffset) * absoluteY) + _minScrollOffset)
        .clamp(_minScrollOffset, _maxScrollOffset!);
    _actualScrollViewOffset = newOffset;

    moveScrollViewToOffset(newOffset);
  }

  void moveScrollViewToOffset(double newOffset) {
    if (widget.isFixedScroll && _fixedItemLength != null) {
      final closestTopItemOffset =
          (newOffset ~/ _fixedItemLength!) * _fixedItemLength! + (_minScrollOffset % _fixedItemLength!);
      final closestBottomItemOffset =
          (newOffset ~/ _fixedItemLength! + 1) * _fixedItemLength! + (_minScrollOffset % _fixedItemLength!);

      if (closestTopItemOffset < _minScrollOffset) {
        _scrollController!.jumpTo(_minScrollOffset);
        return;
      }

      if (closestBottomItemOffset > _maxScrollOffset!) {
        _scrollController!.jumpTo(_maxScrollOffset!);
        return;
      }

      final newScrollControllerOffset =
          closest(newOffset, closestTopItemOffset, closestBottomItemOffset).clamp(_minScrollOffset, _maxScrollOffset!);
      _scrollController!.jumpTo(newScrollControllerOffset);
    } else {
      _scrollController!.jumpTo(_actualScrollViewOffset);
    }
  }
}

double closest(double value, double num1, double num2) {
  double diff1 = (value - num1).abs();
  double diff2 = (value - num2).abs();

  return (diff1 < diff2) ? num1 : num2;
}
