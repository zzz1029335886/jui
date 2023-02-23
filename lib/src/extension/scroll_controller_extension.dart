import 'dart:math';

import 'package:flutter/material.dart';

extension ScrollControllerExtension on ScrollController {
  Future<void> scrollToKey(
      {required GlobalKey scrollKey,
      required GlobalKey targetKey,
      double padding = 0}) async {
    final RenderBox? overlay =
        scrollKey.currentContext!.findRenderObject() as RenderBox?;

    final RenderBox dropDownItemRenderBox =
        targetKey.currentContext!.findRenderObject() as RenderBox;

    var position =
        dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
    var dy = position.dy + offset - padding;
    scrollTo(dy);
  }

  Future<void> scrollToBottom() {
    var maxScrollExtent = position.maxScrollExtent;
    return scrollTo(maxScrollExtent);
  }

  Future<void> scrollToTop() {
    return scrollTo(0);
  }

  Future<void> scrollTo(double dy) async {
    var maxScrollExtent = position.maxScrollExtent;
    if (dy > maxScrollExtent) {
      dy = maxScrollExtent;
    }

    final value = (offset - dy) * 0.5;
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
      valueChanged(value);
    });
  }
}
