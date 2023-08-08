import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JUIFormStyle {
  late double? titleWidth; // 标题宽度，默认100
  late double? titleHeight; // 标题宽度，默认空，居中
  late TextStyle? titleStyle; // 标题字体样式，默认颜色black87
  late Color? bgColor; // 背景颜色，默认白色
  late double? height;
  late EdgeInsets? padding;
  late EdgeInsets? margin;
  late bool isHiddenBottomLine; // 隐藏底部横线
  late bool isHiddenTopLine; // 隐藏底部横线
  late double linePadding;
  late bool isTopTitle;
  JUIFormStyle(
      {this.titleStyle,
      this.bgColor,
      this.isTopTitle = false,
      this.height,
      this.isHiddenBottomLine = false,
      this.titleHeight,
      this.isHiddenTopLine = true,
      this.linePadding = 16,
      this.titleWidth,
      this.margin,
      this.padding});

  JUIFormStyle deepCopy() {
    return JUIFormStyle(
      titleHeight: titleHeight,
      titleStyle: titleStyle,
      titleWidth: titleWidth,
      isTopTitle: isTopTitle,
      height: height,
      isHiddenBottomLine: isHiddenBottomLine,
      margin: margin,
      padding: padding,
      isHiddenTopLine: isHiddenTopLine,
      linePadding: linePadding,
      bgColor: bgColor,
    );
  }
}

class JUIFormInputStyle {
  double? minHeight; // input最小高度
  double? maxHeight; // input最大高度
  int maxLength; // 最大长度
  int? maxLines; // 最大行数
  int? minLines; // 最大行数
  Decoration? contentDecoration; // 内容背景
  EdgeInsets? contentPadding; // 内容padding
  String? hintText; // 占位字符
  TextStyle? hintTextStyle; // 占位字符样式
  TextStyle? textStyle; // 占位字符样式
  bool showMaxLength; // 是否显示最大数字长度
  bool isEdit; // 是否可编辑
  List<TextInputFormatter>? inputFormatters; // 输入框formatter
  TextInputType? keyboardType; // 键盘类型
  Widget? leftWidget;
  Widget? rightWidget;
  TextAlign? textAlign;
  bool isShowCleanButton;

  JUIFormInputStyle({
    this.textAlign,
    this.hintTextStyle,
    this.textStyle,
    this.isEdit = true,
    this.contentDecoration,
    this.contentPadding,
    this.hintText,
    this.inputFormatters,
    this.isShowCleanButton = false,
    this.keyboardType,
    this.leftWidget,
    this.maxHeight,
    this.maxLength = 9999,
    this.maxLines,
    this.minLines = 1,
    this.minHeight,
    this.rightWidget,
    this.showMaxLength = false,
  });

  JUIFormInputStyle deepCopy() {
    return JUIFormInputStyle(
        textAlign: textAlign,
        hintText: hintText,
        hintTextStyle: hintTextStyle,
        isEdit: isEdit,
        contentDecoration: contentDecoration,
        contentPadding: contentPadding,
        inputFormatters: inputFormatters,
        isShowCleanButton: isShowCleanButton,
        keyboardType: keyboardType,
        leftWidget: leftWidget,
        textStyle: textStyle,
        maxHeight: maxHeight,
        maxLength: maxLength,
        maxLines: maxLines,
        minHeight: minHeight,
        rightWidget: rightWidget,
        showMaxLength: showMaxLength);
  }
}

class JUIFormBuilder extends StatefulWidget {
  final Widget child;
  final JUIFormStyle? style;
  final JUIFormInputStyle? inputStyle;
  const JUIFormBuilder(
      {super.key, required this.child, this.style, this.inputStyle});

  static JUIFormBuilderState? of(BuildContext context) =>
      context.findAncestorStateOfType<JUIFormBuilderState>();

  @override
  State<JUIFormBuilder> createState() => JUIFormBuilderState();
}

class JUIFormBuilderState extends State<JUIFormBuilder> {
  JUIFormStyle? config;
  JUIFormInputStyle? inputStyle;
  @override
  void initState() {
    config = widget.style;
    inputStyle = widget.inputStyle;
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
