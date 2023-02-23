import 'package:flutter/material.dart';

import 'jui_form_base.dart';

// ignore: must_be_immutable
class JUIFormCustom extends JUIFormBase {
  final Widget child;
  JUIFormCustom(this.child,
      {super.key,
      super.config,
      super.configBuilder,
      super.parentConfigBuilder});

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
