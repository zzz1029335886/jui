import 'package:flutter/material.dart';

import 'jui_form_base.dart';
import 'jui_form_content.dart';

// ignore: must_be_immutable
class JUIFormSelect extends JUIFormContent {
  final bool hiddenArrow;
  final VoidCallback? clickCallback;
  final String? placeholder;
  final TextStyle? contentTextStyle;
  final TextStyle? placeholderTextStyle;
  JUIFormSelect(
      {super.key,
      super.content,
      this.contentTextStyle,
      this.placeholderTextStyle = const TextStyle(
          color: Color.fromRGBO(183, 187, 191, 1), fontSize: 14),
      this.placeholder,
      this.clickCallback,
      this.hiddenArrow = false,
      super.config,
      super.configBuilder,
      super.contentStyle,
      super.parentConfigBuilder});

  @override
  JUIFormBaseState<JUIFormBase> createState() => _JUIFormSelectState();
}

class _JUIFormSelectState extends JUIFormBaseState<JUIFormSelect> {
  @override
  Widget contentBuild(BuildContext context) {
    return Row(
      children: [
        if (widget.content != null)
          Text(
            widget.content!,
            style: widget.contentTextStyle,
          ),
        if (widget.content == null && widget.placeholder != null)
          Text(
            widget.placeholder!,
            style: widget.placeholderTextStyle,
          ),
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
