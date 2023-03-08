import 'package:flutter/material.dart';

class JUIEnabled extends StatelessWidget {
  final Widget child;
  final bool isEnabled;

  /// isEnabled为false 透明度改变后仍然可点击
  final bool isIgnoring;
  final double opacity;

  const JUIEnabled({
    super.key,
    required this.child,
    required this.isEnabled,
    this.opacity = 0.6,
    this.isIgnoring = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isEnabled) {
      return child;
    } else {
      var widget = Opacity(
        opacity: opacity,
        child: child,
      );
      if (!isIgnoring) {
        return widget;
      }
      return IgnorePointer(
        ignoring: isIgnoring,
        child: widget,
      );
    }
  }
}
