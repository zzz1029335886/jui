import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../other/cf_text_field.dart';
import 'jui_form_base.dart';
import 'jui_form_content.dart';

class JUIFormInput extends JUIFormContent {
  final double? minHeight; // input最小高度
  final double? maxHeight; // input最大高度
  final int maxLength; // 最大长度
  final int? maxLines; // 最大行数
  final Decoration? contentDecoration; // 内容背景
  final EdgeInsets? contentPadding; // 内容padding
  final String? hintText; // 占位字符
  final TextStyle? hintTextStyle; // 占位字符样式
  final TextStyle? textStyle; // 占位字符样式
  final bool showMaxLength; // 是否显示最大数字长度
  final bool isEdit; // 是否可编辑
  final List<TextInputFormatter>? inputFormatters; // 输入框formatter
  final TextInputType? keyboardType; // 键盘类型
  final Widget? leftWidget;
  final TextAlign? textAlign;
  final bool isShowCleanButton;
  JUIFormInput(
      {super.key,
      this.isEdit = true,
      this.textAlign,
      this.leftWidget,
      this.maxLines,
      this.hintText,
      this.keyboardType,
      this.hintTextStyle = const TextStyle(
        color: Color.fromRGBO(183, 187, 191, 1),
        fontSize: 14,
      ),
      this.textStyle,
      this.contentPadding = const EdgeInsets.only(top: 3),
      this.contentDecoration,
      this.maxLength = 9999,
      this.minHeight,
      this.maxHeight,
      this.showMaxLength = false,
      super.content,
      this.inputFormatters,
      this.isShowCleanButton = false,
      super.config,
      super.configBuilder});

  @override
  JUIFormBaseState<JUIFormBase> createState() => _JUIFormInputState();
}

class _JUIFormInputState extends JUIFormBaseState<JUIFormInput> {
  @override
  Widget contentBuild(BuildContext context) {
    return _mainWidget(
      child: Container(
        padding: widget.contentPadding,
        decoration: widget.contentDecoration,
        // color: Colors.amber,
        height: widget.minHeight == widget.maxHeight && widget.minHeight != null
            ? widget.minHeight
            : null,
        constraints: widget.minHeight != null && widget.maxHeight != null
            ? BoxConstraints(
                minHeight: widget.minHeight!, maxHeight: widget.maxHeight!)
            : null,
        child: CFTextField(
          text: widget.content,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          textStyle: widget.textStyle,
          hintText: widget.hintText ?? '请输入',
          inputFormatters: widget.inputFormatters,
          hintTextStyle: widget.hintTextStyle,
          textAlign: widget.textAlign ?? TextAlign.left,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          showMaxLength: widget.showMaxLength,
          enabled: widget.isEdit,
          isShowCleanButton: widget.isShowCleanButton,
        ),
      ),
    );
  }

  Widget _mainWidget({required Widget child}) {
    if (widget.config != null && widget.config!.isTopTitle) {
      return child;
    } else {
      return Expanded(child: child);
    }
  }

  @override
  MainAxisAlignment? get mainAxisAlignment => MainAxisAlignment.center;
}
