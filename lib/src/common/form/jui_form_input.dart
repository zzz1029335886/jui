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
  final int? minLines; // 最小行数
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
  final TextEditingController? controller;
  JUIFormInput(
      {super.key,
      this.controller,
      this.valueChanged,
      this.isEdit,
      this.textAlign,
      this.leftWidget,
      this.rightWidget,
      this.maxLines,
      this.minLines = 1,
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
  JUIFormInputStyle? get inputStyle => formBuilderState?.inputStyle;

  double? get minHeight => widget.minHeight ?? inputStyle?.minHeight;
  double? get maxHeight => widget.maxHeight ?? inputStyle?.maxHeight;

  @override
  Widget contentBuild(BuildContext context) {
    var contentPadding = widget.contentPadding ?? inputStyle?.contentPadding;
    var contentDecoration =
        widget.contentDecoration ?? inputStyle?.contentDecoration;
    var maxLength = widget.maxLength ?? inputStyle?.maxLength ?? 100;
    var maxLines = widget.maxLines ?? inputStyle?.maxLines;
    var minLines = widget.minLines ?? inputStyle?.minLines;
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

    var _height =
        minHeight == maxHeight && minHeight != null ? minHeight : null;
    var _constraints = minHeight != null && minHeight != maxHeight
        ? BoxConstraints(
            minHeight: minHeight!, maxHeight: maxHeight ?? double.infinity)
        : null;

    return _mainWidget(
      child: Container(
        padding: contentPadding,
        decoration: contentDecoration,
        height: _height,
        constraints: _constraints,
        child: CFTextField(
          text: widget.content,
          maxLength: maxLength,
          minLines: minLines ?? 1,
          maxLines: maxLines ?? 1,
          controller: widget.controller,
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

  // @override
  // CrossAxisAlignment? get crossAxisAlignment {
  //   if (maxHeight == null) {
  //     return CrossAxisAlignment.stretch;
  //   }
  //   return CrossAxisAlignment.start;
  // }

  // @override
  // Widget titleContainer({required Widget child}) {
  //   if (maxHeight == null) {
  //     return isTopTitle
  //         ? child
  //         : Column(
  //             children: [child, Expanded(child: Container())],
  //           );
  //   }
  //   return child;
  // }
}
