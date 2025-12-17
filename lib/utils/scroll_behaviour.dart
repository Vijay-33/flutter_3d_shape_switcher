import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A [ScrollBehavior] that allows scrolling with mouse drag and trackpad.
class MouseDraggableScrollBehavior extends MaterialScrollBehavior {
  const MouseDraggableScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {...super.dragDevices, PointerDeviceKind.mouse, PointerDeviceKind.trackpad};
}
