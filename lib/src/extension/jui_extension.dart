import 'package:flutter/material.dart';

export 'scroll_controller_extension.dart';

extension JUIFontWeightExtension on FontWeight {
  static const isIos = false;
  static const FontWeight medium = isIos ? FontWeight.w600 : FontWeight.w600;
}
