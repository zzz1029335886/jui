import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class JUIFormBuilder extends StatefulWidget {
  final Widget child;
  final JUIFormConfig? config;
  const JUIFormBuilder({super.key, required this.child, this.config});

  static JUIFormBuilderState? of(BuildContext context) =>
      context.findAncestorStateOfType<JUIFormBuilderState>();

  @override
  State<JUIFormBuilder> createState() => JUIFormBuilderState();
}

class JUIFormBuilderState extends State<JUIFormBuilder> {
  JUIFormConfig? config;
  @override
  void initState() {
    config = widget.config;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: widget.child,
    );
  }
}
