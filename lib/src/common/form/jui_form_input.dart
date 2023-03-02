import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jui/jui.dart';

import 'jui_form_content.dart';

// ignore: must_be_immutable
class JUIFormInput extends JUIFormContent {
  final double? minHeight; // input最小高度
  final double? maxHeight; // input最大高度
  final int? maxLength; // 最大长度
  final int? maxLines; // 最大行数
  final Decoration? contentDecoration; // 内容背景
  final EdgeInsets? contentPadding; // 内容padding
  final String? hintText; // 占位字符
  final TextStyle? hintTextStyle; // 占位字符样式
  final TextStyle? textStyle; // 占位字符样式
  final bool? showMaxLength; // 是否显示最大数字长度
  final bool? isEdit; // 是否可编辑
  final List<TextInputFormatter>? inputFormatters; // 输入框formatter
  final TextInputType? keyboardType; // 键盘类型
  final Widget? leftWidget;
  final Widget? rightWidget;
  final TextAlign? textAlign;
  final bool? isShowCleanButton;
  final ValueChanged<String?>? valueChanged;

  JUIFormInput(
      {super.key,
      this.valueChanged,
      this.isEdit,
      this.textAlign,
      this.leftWidget,
      this.rightWidget,
      this.maxLines,
      this.hintText,
      this.keyboardType,
      this.hintTextStyle,
      this.textStyle,
      this.contentPadding,
      this.contentDecoration,
      this.maxLength,
      this.minHeight,
      this.maxHeight,
      this.showMaxLength,
      super.content,
      this.inputFormatters,
      this.isShowCleanButton,
      super.config,
      super.style,
      super.styleBuilder,
      super.contentStyle});

  @override
  JUIFormBaseState<JUIFormBase> createState() => _JUIFormInputState();
}

class _JUIFormInputState extends JUIFormBaseState<JUIFormInput> {
  @override
  Widget contentBuild(BuildContext context) {
    JUIFormInputStyle? inputStyle = formBuilderState?.inputStyle;
    var contentPadding = widget.contentPadding ?? inputStyle?.contentPadding;
    var contentDecoration =
        widget.contentDecoration ?? inputStyle?.contentDecoration;
    var minHeight = widget.minHeight ?? inputStyle?.minHeight;
    var maxHeight = widget.maxHeight ?? inputStyle?.maxHeight;
    var maxLength = widget.maxLength ?? inputStyle?.maxLength ?? 100;
    var maxLines = widget.maxLines ?? inputStyle?.maxLines;
    var textStyle = widget.textStyle ?? inputStyle?.textStyle;
    var leftWidget = widget.leftWidget ?? inputStyle?.leftWidget;
    var rightWidget = widget.rightWidget ?? inputStyle?.rightWidget;
    var hintText = widget.hintText ?? inputStyle?.hintText;
    var inputFormatters = widget.inputFormatters ?? inputStyle?.inputFormatters;
    var hintTextStyle = widget.hintTextStyle ?? inputStyle?.hintTextStyle;
    var textAlign = widget.textAlign ?? inputStyle?.textAlign;
    var keyboardType = widget.keyboardType ?? inputStyle?.keyboardType;
    var showMaxLength = widget.showMaxLength ?? inputStyle?.showMaxLength;
    var isEdit = widget.isEdit ?? inputStyle?.isEdit;
    var isShowCleanButton =
        widget.isShowCleanButton ?? inputStyle?.isShowCleanButton;

    return _mainWidget(
      child: Container(
        padding: contentPadding,
        decoration: contentDecoration,
        // color: Colors.amber,
        height: minHeight == maxHeight && minHeight != null ? minHeight : null,
        constraints: minHeight != null && maxHeight != null
            ? BoxConstraints(minHeight: minHeight, maxHeight: maxHeight)
            : null,
        child: CFTextField(
          text: widget.content,
          maxLength: maxLength,
          maxLines: maxLines,
          textStyle: textStyle,
          leftWidget: leftWidget,
          rightWidget: rightWidget,
          hintText: hintText ?? '请输入',
          inputFormatters: inputFormatters,
          hintTextStyle: hintTextStyle,
          textAlign: textAlign ?? TextAlign.left,
          keyboardType: keyboardType ?? TextInputType.text,
          showMaxLength: showMaxLength ?? false,
          enabled: isEdit ?? true,
          isShowCleanButton: isShowCleanButton ?? false,
          inputCompletionCallBack: (value, isSubmitted) {
            widget.valueChanged?.call(value);
          },
        ),
      ),
    );
  }

  Widget _mainWidget({required Widget child}) {
    if (getStyle().isTopTitle) {
      return child;
    } else {
      return Expanded(child: child);
    }
  }

  @override
  MainAxisAlignment? get mainAxisAlignment => MainAxisAlignment.center;
}
