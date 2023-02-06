import 'package:flutter/material.dart';

import 'jui_form_base.dart';

class JUIFormCustom extends JUIFormBase {
  final Widget child;
  const JUIFormCustom(this.child, {super.key, required super.config});

  @override
  JUIFormBaseState<JUIFormBase> createState() => _JUIFormCustomState();
}

class _JUIFormCustomState extends JUIFormBaseState<JUIFormCustom> {
  @override
  Widget contentBuild(BuildContext context) {
    return widget.child;
  }

  @override
  MainAxisAlignment? get mainAxisAlignment => MainAxisAlignment.spaceBetween;
}
