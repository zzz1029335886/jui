import 'package:flutter/material.dart';

import 'jui_form_builder.dart';

class JUIFormConfig {
  late bool isTopTitle;
  late String? title; // 标题
  late double? titleWidth; // 标题宽度，默认100
  late double? titleHeight; // 标题宽度，默认空，居中
  late TextStyle titleStyle; // 标题字体样式，默认颜色black87
  late Color bgColor; // 背景颜色，默认白色
  late double? height;
  late EdgeInsets padding;
  late EdgeInsets margin;
  late bool isHiddenBottomLine; // 隐藏底部横线
  late bool isHiddenTopLine; // 隐藏底部横线
  late bool isShowRedStar;
  late Icon? icon;
  late Widget? leftWidget;
  late Widget? tipWidget;
  late String? tip;
  late Color? tipBgColor; // 背景颜色，默认白色
  late TextStyle tipStyle;
  late double linePadding;

  JUIFormConfig(
      {this.isTopTitle = false,
      this.title,
      this.leftWidget,
      this.linePadding = 16,
      this.tip,
      this.tipStyle = const TextStyle(
          fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
      this.icon,
      this.isHiddenBottomLine = false,
      this.isHiddenTopLine = true,
      this.height,
      this.isShowRedStar = false,
      this.titleHeight,
      this.titleWidth = 100,
      this.titleStyle = const TextStyle(color: Colors.black87),
      this.bgColor = Colors.white,
      this.tipBgColor,
      this.tipWidget,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero});

  Widget getTipWidget() {
    var config = this;

    return Container(
      color: config.tipBgColor,
      child: Padding(
        padding: EdgeInsets.only(
            left: config.padding.left,
            right: config.padding.right,
            top: 8,
            bottom: 8),
        child: Text(
          config.tip!,
          style: config.tipStyle,
        ),
      ),
    );
  }
}

/// [configBuilder] 默认高度44，为输入框时需置空
typedef JUIFormConfigBuilder = JUIFormConfig Function(JUIFormConfig config);

// ignore: must_be_immutable
abstract class JUIFormBase extends StatefulWidget {
  JUIFormConfig? config;
  final JUIFormConfigBuilder? parentConfigBuilder;

  /// [configBuilder] 默认高度44，为输入框时需置空
  JUIFormBase(
      {this.config,
      JUIFormConfigBuilder? configBuilder,
      this.parentConfigBuilder,
      super.key})
      : super() {
    assert(configBuilder != null || config != null);
    if (config == null && configBuilder != null) {
      JUIFormConfig defaultConfig = JUIFormConfig();
      defaultConfig.height = 44;
      config = configBuilder.call(defaultConfig);
    }
  }

  @override
  JUIFormBaseState createState();
}

@optionalTypeArgs
abstract class JUIFormBaseState<T extends JUIFormBase> extends State<T> {
  JUIFormConfig getConfig() {
    return widget.config ?? JUIFormConfig();
  }

  // ignore: slash_for_doc_comments
  /**
   * 获取content内容宽度，去掉边距与标题宽度
   */
  double get contentWidth {
    var screenWidth = MediaQuery.of(context).size.width;
    var config = getConfig();

    var width = screenWidth -
        config.padding.left -
        config.padding.right -
        config.margin.left -
        config.margin.right;

    if (!config.isTopTitle) {
      double titleWidth = 0;
      if (config.title != null && config.titleWidth == null) {
        titleWidth = _textWidth(config.title!, config.titleStyle);
        if (config.isShowRedStar) {
          titleWidth += 3 + _textWidth('*', _redStarTextStyle);
        }
      } else {
        titleWidth = config.titleWidth ?? 0;
      }

      width -= titleWidth;
    }

    return width;
  }

/**
 * 计算文本内容宽度
 */
  double _textWidth(String title, TextStyle textStyle) {
    var tp = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: title, style: textStyle))
      ..layout();

    return tp.width;
  }

  JUIFormBuilderState? formBuilderState;

  @override
  void initState() {
    formBuilderState = JUIFormBuilder.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var config = getConfig();

    Widget contentWidget = Container(
      color: config.bgColor,
      padding: config.padding,
      margin: config.margin,
      height: config.height != null
          ? (config.height! -
              (config.isHiddenTopLine ? 0.5 : 0) - // 减上边距
              (config.isHiddenBottomLine ? 0.5 : 0) - // 减下边距
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
      child: mainWidget(!config.isTopTitle),
    );

    if (!config.isHiddenTopLine || !config.isHiddenBottomLine) {
      // 设置上下边距
      contentWidget = Column(
        children: [
          if (!config.isHiddenTopLine)
            Container(
              margin: EdgeInsets.symmetric(horizontal: config.linePadding),
              color: const Color(0xFFE6E6E6),
              height: 0.5,
            ),
          contentWidget,
          if (!config.isHiddenBottomLine)
            Container(
              margin: EdgeInsets.symmetric(horizontal: config.linePadding),
              color: const Color(0xFFE6E6E6),
              height: 0.5,
            ),
        ],
      );
    }

    if (config.tip == null && config.tipWidget == null) {
      return cellContainer(child: contentWidget);
    }

    Widget tip = config.tipWidget ?? config.getTipWidget();

    Widget widget = cellContainer(child: contentWidget);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [widget, tip],
    );
  }

  Widget mainWidget(
    isRow,
  ) {
    var config = getConfig();
    Widget res;
    if (isRow) {
      res = Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: config.height != null && config.titleHeight == null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (config.title != null) titleWidget(),
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
          if (config.title != null) titleWidget(),
          contentBuild(context)
        ],
      );
    }

    return res;
  }

  Widget titleWidget() {
    var config = getConfig();

    return Container(
      alignment: Alignment.center,
      width: config.titleWidth,
      height: config.titleHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (config.leftWidget != null) config.leftWidget!,
          if (config.icon != null) config.icon!,
          Text(
            config.title!,
            style: config.titleStyle,
          ),
          if (config.isShowRedStar)
            Container(
                margin: const EdgeInsets.only(top: 5, left: 3),
                child: Text('*', style: _redStarTextStyle)),
        ],
      ),
    );
  }

  late TextStyle _redStarTextStyle =
      const TextStyle(fontSize: 18.0, color: Colors.red);

  @protected
  Widget contentBuild(BuildContext context);

  MainAxisAlignment? mainAxisAlignment;

  Widget cellContainer({required Widget child}) {
    return child;
  }
}
