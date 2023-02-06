import 'package:flutter/material.dart';

class JUIFormConfig {
  final bool isTopTitle;
  final String? title; // 标题
  final double? titleWidth; // 标题宽度，默认100
  final double? titleHeight; // 标题宽度，默认空，居中
  final TextStyle titleStyle; // 标题字体样式，默认颜色black87
  final Color bgColor; // 背景颜色，默认白色
  final double? height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool isHiddenBottomLine; // 隐藏底部横线
  final bool isHiddenTopLine; // 隐藏底部横线
  final bool isShowRedStar;
  final Icon? icon;
  final Widget? leftWidget;
  final String? tip;
  final Color? tipBgColor; // 背景颜色，默认白色
  final TextStyle tipStyle;
  final double linePadding;

  const JUIFormConfig(
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
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero});
}

abstract class JUIFormBase extends StatefulWidget {
  final JUIFormConfig config;
  const JUIFormBase({required this.config, super.key});

  @override
  JUIFormBaseState createState();
}

@optionalTypeArgs
abstract class JUIFormBaseState<T extends JUIFormBase> extends State<T> {
  // ignore: slash_for_doc_comments
  /**
   * 获取content内容宽度，去掉边距与标题宽度
   */
  double get contentWidth {
    var screenWidth = MediaQuery.of(context).size.width;

    var width = screenWidth -
        widget.config.padding.left -
        widget.config.padding.right -
        widget.config.margin.left -
        widget.config.margin.right;

    if (!widget.config.isTopTitle) {
      double titleWidth = 0;
      if (widget.config.title != null && widget.config.titleWidth == null) {
        titleWidth = _textWidth(widget.config.title!, widget.config.titleStyle);
        if (widget.config.isShowRedStar) {
          titleWidth += 3 + _textWidth('*', _redStarTextStyle);
        }
      } else {
        titleWidth = widget.config.titleWidth ?? 0;
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

  @override
  Widget build(BuildContext context) {
    var config = widget.config;

    Widget contentWidget = Container(
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

    if (config.tip != null) {
      contentWidget = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          contentWidget,
          Container(
            color: config.tipBgColor,
            width: double.infinity,
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
          )
        ],
      );
    }

    return cellContainer(child: contentWidget);
  }

  Widget mainWidget(
    isRow,
  ) {
    var config = widget.config;
    Widget res;
    if (isRow) {
      res = Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: config.height != null && config.titleHeight == null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (widget.config.title != null) titleWidget(),
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
          if (widget.config.title != null) titleWidget(),
          contentBuild(context)
        ],
      );
    }

    return res;
  }

  Widget titleWidget() {
    var config = widget.config;

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
            widget.config.title!,
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

  final TextStyle _redStarTextStyle =
      const TextStyle(fontSize: 18.0, color: Colors.red);

  @protected
  Widget contentBuild(BuildContext context);

  MainAxisAlignment? mainAxisAlignment;

  Widget cellContainer({required Widget child}) {
    return child;
  }
}
