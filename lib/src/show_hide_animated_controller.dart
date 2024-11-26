import 'dart:async';

class ShowHideAnimatedController {
  ShowHideAnimatedController(
      {required bool Function() mustBeHidden,
      required Duration durationBeforePlannedHidding})
      : _durationBeforePlannedHidding = durationBeforePlannedHidding,
        _mustBeHidden = mustBeHidden;

  final bool Function() _mustBeHidden;
  Duration _durationBeforePlannedHidding;

  Timer? _plannedUpdate;

  bool _isShown = false;
  final StreamController<bool> _isShownStreamController =
      StreamController<bool>.broadcast();

  bool get isShown => _isShown;
  Stream<bool> get isShownStream => _isShownStreamController.stream;

  void dispose() {
    _plannedUpdate?.cancel();
  }

  void setDurationBeforePlannedHidding(
      Duration newDurationBeforePlannedHidding) {
    _durationBeforePlannedHidding = newDurationBeforePlannedHidding;
  }

  void maybeUpdate() {
    _maybeHide();
    _maybeShow();
  }

  void maybeScheduleUpdate() {
    if (_shouldBeShown() || _shouldHide()) {
      _cancelPlannedLabelHiddingIfNeed();
      _plannedUpdate = Timer(_durationBeforePlannedHidding, () {
        if (_shouldHide()) {
          _hide();
        }

        if (_shouldBeShown()) {
          _show();
        }
      });
    }
  }

  bool _shouldHide() => _mustBeHidden() && _isShown;
  bool _shouldBeShown() => !_mustBeHidden() && !_isShown;

  void _maybeHide() {
    if (_shouldHide()) {
      _cancelPlannedLabelHiddingIfNeed();
      _hide();
    }
  }

  void _maybeShow() {
    if (_shouldBeShown()) {
      _cancelPlannedLabelHiddingIfNeed();
      _show();
    }
  }

  void _cancelPlannedLabelHiddingIfNeed() {
    if (_plannedUpdate?.isActive ?? false) {
      _plannedUpdate?.cancel();
    }
    _plannedUpdate = null;
  }

  void _show() {
    if (!_isShown) {
      _isShown = true;
      _isShownStreamController.add(true);
    }
  }

  void _hide() {
    if (_isShown) {
      _isShown = false;
      _isShownStreamController.add(false);
    }
  }
}
