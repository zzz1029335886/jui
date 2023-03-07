import 'dart:math';

import 'package:flutter/material.dart';

enum ScrollControllerChildPosition {
  top,
  bottom,
  center,
  leading,
  traling,
  inScreen
}

extension ScrollControllerExtension on ScrollController {
  Future<void> scrollToKey(
      {required GlobalKey scrollKey,
      required GlobalKey targetKey,
      double padding = 0,
      ScrollControllerChildPosition scrollPosition =
          ScrollControllerChildPosition.top,
      bool isAnimated = true}) async {
    final RenderBox? scrollRenderBox =
        scrollKey.currentContext!.findRenderObject() as RenderBox?;
    if (scrollRenderBox == null) {
      return;
    }

    final RenderBox targetRenderBox =
        targetKey.currentContext!.findRenderObject() as RenderBox;
    double dy = 0;

    switch (scrollPosition) {
      case ScrollControllerChildPosition.top:
        Offset position = targetRenderBox.localToGlobal(Offset.zero,
            ancestor: scrollRenderBox);
        dy = position.dy + offset;
        break;
      case ScrollControllerChildPosition.bottom:
        Offset position = targetRenderBox.localToGlobal(
            Offset(0, targetRenderBox.size.height),
            ancestor: scrollRenderBox);
        dy = position.dy + offset - scrollRenderBox.size.height;
        break;
      case ScrollControllerChildPosition.center:
        if (isVertical) {
          Offset point = targetRenderBox.localToGlobal(
              Offset(0, targetRenderBox.size.height * 0.5),
              ancestor: scrollRenderBox);
          dy = point.dy + offset - scrollRenderBox.size.height * 0.5;
        } else {
          Offset point = targetRenderBox.localToGlobal(
              Offset(0, targetRenderBox.size.width * 0.5),
              ancestor: scrollRenderBox);
          dy = point.dx +
              offset -
              scrollRenderBox.size.width * 0.5 +
              targetRenderBox.size.width * 0.5;
        }

        break;
      case ScrollControllerChildPosition.leading:
        Offset position = targetRenderBox.localToGlobal(Offset.zero,
            ancestor: scrollRenderBox);
        dy = position.dx + offset;
        break;
      case ScrollControllerChildPosition.traling:
        Offset position = targetRenderBox.localToGlobal(
            Offset(0, targetRenderBox.size.width),
            ancestor: scrollRenderBox);
        dy = position.dx +
            offset -
            scrollRenderBox.size.width +
            targetRenderBox.size.width;
        break;

      default:
        Offset position = targetRenderBox.localToGlobal(Offset.zero,
            ancestor: scrollRenderBox);
        var targetSizeValue = 0.0;
        var scrollSizeValue = 0.0;
        if (isVertical) {
          dy = position.dy;
          targetSizeValue = targetRenderBox.size.height;
          scrollSizeValue = scrollRenderBox.size.height;
        } else {
          dy = position.dx;
          targetSizeValue = targetRenderBox.size.width;
          scrollSizeValue = scrollRenderBox.size.width;
        }
        if (dy < 0) {
          scrollToKey(
              scrollKey: scrollKey,
              targetKey: targetKey,
              padding: padding,
              scrollPosition: isVertical
                  ? ScrollControllerChildPosition.top
                  : ScrollControllerChildPosition.leading);
        } else if (dy + targetSizeValue > scrollSizeValue) {
          scrollToKey(
              scrollKey: scrollKey,
              targetKey: targetKey,
              padding: -padding,
              scrollPosition: isVertical
                  ? ScrollControllerChildPosition.bottom
                  : ScrollControllerChildPosition.traling);
        }
        return;
    }

    return scrollTo(dy - padding, isAnimated: isAnimated);
  }

  bool get isVertical => position.axis == Axis.vertical;

  Future<void> scrollToBottom({bool isAnimated = true}) {
    var maxScrollExtent = position.maxScrollExtent;
    return scrollTo(maxScrollExtent, isAnimated: isAnimated);
  }

  Future<void> scrollToTop({bool isAnimated = true}) {
    return scrollTo(0, isAnimated: isAnimated);
  }

  Future<void> scrollTo(double dy, {bool isAnimated = true}) async {
    var maxScrollExtent = position.maxScrollExtent;

    if (dy > maxScrollExtent) {
      dy = maxScrollExtent;
    } else if (dy < 0) {
      dy = 0;
    }

    final value = (offset - dy) * 0.5;
    if (value == 0) {
      return;
    }

    if (!isAnimated) {
      jumpTo(dy);
    }
    final milliseconds = value.toInt().abs() + 100;

    final duration = Duration(milliseconds: milliseconds);

    animateTo(dy, duration: duration, curve: Curves.ease);
    await Future.delayed(duration);
  }

  void addListenerReturnProgress(
      {required double height,
      required ValueChanged<double> valueChanged,
      double maxValue = 1,
      double minValue = 0}) {
    addListener(() {
      double alpha = 0;
      if (offset > 0) {
        alpha = 1 - (height - offset) / height;
      } else {
        alpha = 0;
      }
      double value = max(min(alpha, maxValue), minValue);
      int intValue = (value * 1000).round();

      valueChanged(intValue / 1000.0);
    });
  }
}
