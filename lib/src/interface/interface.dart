import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef TabViewBuilder = Widget Function(
    int index, String value, TabController tabController);

typedef OnTabSelected = void Function(
    int index, String value, TabController tabController);

class JuiTabBarWidget extends StatefulWidget {
  final List<String> tabValues;
  final int initialIndex;
  final String? styleType;
  final TabViewBuilder tabViewBuilder;
  final OnTabSelected? onTabSelected;
  final Map<String, dynamic>? extra;

  const JuiTabBarWidget(
      {Key? key,
      required this.tabValues,
      required this.initialIndex,
      required this.tabViewBuilder,
      this.onTabSelected,
      this.extra,
      this.styleType})
      : super(key: key);

  @override
  State<JuiTabBarWidget> createState() => _JuiTabBarWidgetState();
}

class _JuiTabBarWidgetState extends State<JuiTabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class InputEditWidget extends StatefulWidget {
  final Text hintText;
  final String? styleType;
  final Widget? leftIcon;
  final bool? showBorder; //外部边框 默认不显示

  final int maxLength; // 最大长度
  final int? maxLines; // 最大行数 默认单行
  final bool? isEdit; // 是否可编辑 默认true
  final List<TextInputFormatter>? inputFormatters; // 输入框formatter
  final TextInputType? keyboardType; // 键盘类型
  const InputEditWidget(
      {Key? key,
      required this.hintText,
      required this.maxLength,
      this.styleType,
      this.leftIcon,
      this.showBorder,
      this.maxLines,
      this.isEdit,
      this.inputFormatters,
      this.keyboardType})
      : super(key: key);

  @override
  State<InputEditWidget> createState() => _InputEditWidgetState();
}

class _InputEditWidgetState extends State<InputEditWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
