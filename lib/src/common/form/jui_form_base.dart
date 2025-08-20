import 'package:flutter/material.dart';

import 'jui_form.dart';

class JUIFormConfig {
  late String? title; // 标题
  late bool isShowRedStar;
  late Icon? icon;
  late Widget? leftWidget;
  late Widget? tipWidget;
  late String? tip;
  late Color? tipBgColor; // 背景颜色，默认白色
  late TextStyle tipStyle;

  JUIFormConfig({
    this.title,
    this.leftWidget,
    this.tip,
    this.tipStyle =
        const TextStyle(fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
    this.icon,
    this.isShowRedStar = false,
    this.tipBgColor,
    this.tipWidget,
  });

  Widget getTipWidget({
    required double paddingLeft,
    required double paddingRight,
  }) {
    return createTipWidget(
        tipBgColor: tipBgColor,
        paddingLeft: paddingLeft,
        paddingRight: paddingRight,
        tip: tip!,
        tipStyle: tipStyle);
  }

  static Widget createTipWidget(
      {Color? tipBgColor,
      required double paddingLeft,
      required double paddingRight,
      required String tip,
      required TextStyle tipStyle}) {
    return Container(
      color: tipBgColor,
      child: Padding(
        padding: EdgeInsets.only(
            left: paddingLeft, right: paddingRight, top: 8, bottom: 8),
        child: Text(
          tip,
          style: tipStyle,
        ),
      ),
    );
  }
}

/// [configBuilder] 默认高度44，为输入框时需置空
typedef JUIFormStyleBuilder = void Function(JUIFormStyle style);

// ignore: must_be_immutable
abstract class JUIFormBase extends StatefulWidget {
  JUIFormConfig? config;
  JUIFormStyle? style;
  JUIFormStyleBuilder? styleBuilder;

  /// [styleBuilder] 默认高度44，为输入框时需置空
  JUIFormBase({this.config, this.styleBuilder, this.style, super.key});

  @override
  JUIFormBaseState createState();
}

@optionalTypeArgs
abstract class JUIFormBaseState<T extends JUIFormBase> extends State<T> {
  late JUIFormStyle defaultStyle = JUIFormStyle();
  JUIFormStyle getStyle() {
    if (widget.style != null) {
      return widget.style!;
    }
    var style = formBuilderState?.widget.style;
    if (style != null) {
      defaultStyle = style.deepCopy();
    }
    if (widget.styleBuilder != null) {
      widget.styleBuilder!.call(defaultStyle);
    }
    return defaultStyle;
  }

  JUIFormConfig? getConfig() {
    return widget.config;
  }

  bool get isTopTitle => getStyle().isTopTitle;

  // ignore: slash_for_doc_comments
  /**
   * 获取content内容宽度，去掉边距与标题宽度
   */
  double get contentWidth {
    var screenWidth = MediaQuery.of(context).size.width;
    var config = getConfig();

    var width = screenWidth -
        stylePadding.left -
        stylePadding.right -
        styleMargin.left -
        styleMargin.right;

    if (!isTopTitle) {
      double realTitleWidth = 0;
      if (config?.title != null && titleWidth == null) {
        realTitleWidth = _textWidth(config!.title!, titleStyle);
        if (config.isShowRedStar) {
          realTitleWidth += 3 + _textWidth('*', _redStarTextStyle);
        }
      } else {
        realTitleWidth = titleWidth ?? 0;
      }

      width -= realTitleWidth;
    }

    return width;
  }

  /// 计算文本内容宽度
  double _textWidth(String title, TextStyle? textStyle) {
    var tp = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: title, style: textStyle))
      ..layout();

    return tp.width;
  }

  JUIFormState? formBuilderState;

  @override
  void initState() {
    formBuilderState = JUIForm.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var config = getConfig();
    var style = getStyle();
    var bgColor = style.bgColor;
    var padding = stylePadding;
    var margin = styleMargin;
    var height = style.height;
    var isHiddenTopLine = style.isHiddenTopLine;
    var isHiddenBottomLine = style.isHiddenBottomLine;
    var isTopTitle = style.isTopTitle;
    var linePadding = style.linePadding;

    Widget contentWidget = Container(
      color: style.decoration == null ? bgColor : null,
      decoration: style.decoration,
      padding: padding,
      margin: margin,
      height: height != null
          ? (height -
              (isHiddenTopLine ? 0.5 : 0) - // 减上边距
              (isHiddenBottomLine ? 0.5 : 0) - // 减下边距
              0)
          : null,
      // decoration: BoxDecoration(
      //     border: Border(
      //         top: config.isHiddenTopLine
      //             ? BorderSide.none
      //             : const BorderSide(width: 0.5, color: Color(0xFFE6E6E6)),
      //         bottom: config.isHiddenBottomLine
      //             ? BorderSide.none
      //             : const BorderSide(width: 0.5, color: Color(0xFFE6E6E6)))),
      child: mainWidget(!isTopTitle),
    );

    if (!isHiddenTopLine || !isHiddenBottomLine) {
      // 设置上下边距
      contentWidget = Column(
        children: [
          if (!isHiddenTopLine)
            Container(
              margin: EdgeInsets.symmetric(horizontal: linePadding),
              color: const Color(0xFFE6E6E6),
              height: 0.5,
            ),
          contentWidget,
          if (!isHiddenBottomLine)
            Container(
              margin: EdgeInsets.symmetric(horizontal: linePadding),
              color: const Color(0xFFE6E6E6),
              height: 0.5,
            ),
        ],
      );
    }

    if (config?.tip == null && config?.tipWidget == null) {
      return cellContainer(child: contentWidget);
    }

    Widget tip = config!.tipWidget ??
        config.getTipWidget(
          paddingLeft: stylePadding.left,
          paddingRight: stylePadding.right,
        );

    Widget widget = cellContainer(child: contentWidget);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [widget, tip],
    );
  }

  Widget mainWidget(bool isRow) {
    var config = getConfig();
    var style = getStyle();
    var height = style.height;

    Widget res;
    if (isRow) {
      res = Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ??
            (height != null && titleHeight == null
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start),
        children: [
          if (config?.title != null) titleWidget(),
          contentBuild(context)
        ],
      );
    } else {
      res = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // crossAxisAlignment: config.height != null && config.titleHeight == null
        //     ? CrossAxisAlignment.center
        //     : CrossAxisAlignment.start,
        children: [
          if (config?.title != null) titleWidget(),
          contentBuild(context)
        ],
      );
    }

    return res;
  }

  JUIFormStyle? get deepStyle => formBuilderState?.widget.style?.deepCopy();
  TextStyle? get titleStyle => getStyle().titleStyle ?? deepStyle?.titleStyle;
  double? get titleWidth => getStyle().titleWidth ?? deepStyle?.titleWidth;
  double? get titleHeight => getStyle().titleHeight ?? deepStyle?.titleHeight;
  EdgeInsets get stylePadding =>
      getStyle().padding ?? deepStyle?.padding ?? EdgeInsets.zero;
  EdgeInsets get styleMargin =>
      getStyle().margin ?? deepStyle?.margin ?? EdgeInsets.zero;
  double get titleBottomPadding =>
      getStyle().titleBottomPadding ?? deepStyle?.titleBottomPadding ?? 0;

  Widget titleWidget() {
    var config = getConfig();

    var title = Container(
      alignment: Alignment.center,
      width: titleWidth,
      height: titleHeight,
      margin: EdgeInsets.only(bottom: titleBottomPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (config?.leftWidget != null) config!.leftWidget!,
          if (config?.icon != null) config!.icon!,
          Text(
            config!.title!,
            style: titleStyle,
          ),
          if (config.isShowRedStar)
            Container(
                margin: const EdgeInsets.only(top: 5, left: 3),
                child: Text('*', style: _redStarTextStyle)),
        ],
      ),
    );

    return titleContainer(child: title);
  }

  late final TextStyle _redStarTextStyle =
      const TextStyle(fontSize: 18.0, color: Colors.red);

  @protected
  Widget contentBuild(BuildContext context);

  MainAxisAlignment? mainAxisAlignment;
  CrossAxisAlignment? crossAxisAlignment;

  Widget cellContainer({required Widget child}) {
    return child;
  }

  Widget titleContainer({required Widget child}) {
    return child;
  }
}
