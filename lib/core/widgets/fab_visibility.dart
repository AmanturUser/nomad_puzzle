import 'package:flutter/material.dart';

/// Tracks whether a modal route (dialog, bottom sheet, popup) is currently on
/// top of the root navigator. Widgets like [ChatFab] use this to fade out
/// while a modal is shown and fade back in when the user dismisses it.
class FabVisibility extends NavigatorObserver {
  FabVisibility._();
  static final FabVisibility instance = FabVisibility._();

  /// `true` while at least one modal is visible.
  final ValueNotifier<bool> hasModal = ValueNotifier<bool>(false);

  int _modalCount = 0;

  bool _isModal(Route<dynamic> route) {
    return route is PopupRoute ||
        route is RawDialogRoute ||
        route is DialogRoute ||
        route is ModalBottomSheetRoute;
  }

  void _bump(int delta) {
    _modalCount = (_modalCount + delta).clamp(0, 1 << 20);
    final next = _modalCount > 0;
    if (next != hasModal.value) hasModal.value = next;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isModal(route)) _bump(1);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isModal(route)) _bump(-1);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isModal(route)) _bump(-1);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null && _isModal(oldRoute)) _bump(-1);
    if (newRoute != null && _isModal(newRoute)) _bump(1);
  }
}
