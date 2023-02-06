import 'package:flutter/material.dart';

import 'jui_form_base.dart';
import 'jui_form_content.dart';

class JUIFormSelect extends JUIFormContent {
  final bool hiddenArrow;
  final VoidCallback? clickCallback;
  const JUIFormSelect(
      {super.key,
      super.content,
      this.clickCallback,
      this.hiddenArrow = false,
      required super.config});

  @override
  JUIFormBaseState<JUIFormBase> createState() => _JUIFormSelectState();
}

class _JUIFormSelectState extends JUIFormBaseState<JUIFormSelect> {
  @override
  Widget contentBuild(BuildContext context) {
    return Row(
      children: [
        if (widget.content != null) Text(widget.content!),
        Offstage(
          offstage: widget.hiddenArrow,
          child: const Icon(Icons.arrow_forward_ios,
              size: 18, color: Color(0xFFC8C8C8)),
        )
      ],
    );
  }

  @override
  Widget cellContainer({required Widget child}) {
    return InkWell(
      onTap: widget.clickCallback,
      child: child,
    );
  }

  @override
  MainAxisAlignment? get mainAxisAlignment => MainAxisAlignment.spaceBetween;
}
