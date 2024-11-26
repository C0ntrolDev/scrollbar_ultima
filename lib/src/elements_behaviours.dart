/// When the Label should be shown or hidden
enum LabelBehaviour {
  /// Label is shown only when the Thumb is shown
  showWhenThumbShown,

  /// Label is shown only while the Thumb is being dragged
  showOnlyWhileDragging,

  /// Label is hown only while and after dragging. When the Thumb is hidden, the state resets
  showOnlyWhileAndAfterDragging
}

/// When the Track should be shown or hidden
enum TrackBehavior {
  /// Track is always shown, regardless of the Thumb
  alwaysShow,

  /// Track is shown only when the Thumb is shown
  showWhenThumbShown,

  /// Track is shown only when the Thumb is hidden
  showWhenThumbNotShown,

  /// Track is shown only while the Thumb is being dragged
  showOnlyWhileDragging
}
