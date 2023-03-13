import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class JUITitleLineWidget extends StatelessWidget {
  /// 是否显示指示器上的竖线
  final bool isShowTopLine;

  /// 高度相同时，每一个的高度
  final double? itemHeight;

  /// 高度不相同时，高度数组
  final List<double>? itemHeights;

  /// 高度不相同时，总高度
  final double? itemsHeight;

  /// 上下间距
  final double itemPadding;

  /// 子集
  final List<Widget> children;

  /// 标题
  final String title;

  /// 自定义标题
  final Widget? customTitle;

  /// 标题
  final TextStyle? titleTextStyle;

  /// 指示器宽度
  final double indicatorWidth;

  /// 指示器颜色
  final Color indicatorColor;

  /// 自定义指示器
  final Widget? customIndicator;

  const JUITitleLineWidget(
      {Key? key,
      required this.title,
      required this.isShowTopLine,
      this.itemPadding = 15,
      this.indicatorColor = const Color.fromRGBO(129, 216, 208, 1),
      this.indicatorWidth = 7.5,
      this.customIndicator,
      this.customTitle,
      this.titleTextStyle,
      this.itemHeight,
      this.itemHeights,
      this.itemsHeight,
      required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalHeight = 0;

    if (itemHeight != null) {
      totalHeight = (itemHeight! + itemPadding) * children.length;
    } else if (itemHeights != null) {
      for (var itemHeight in itemHeights!) {
        totalHeight += itemHeight + itemPadding;
      }
    } else if (itemsHeight != null) {
      totalHeight += itemsHeight! + itemPadding * children.length;
    }

    Widget titleWidget;
    if (customTitle != null) {
      titleWidget = customTitle!;
    } else if (titleTextStyle != null) {
      titleWidget = Text(
        title,
        style: titleTextStyle,
      );
    } else {
      titleWidget = JUIText(
        title,
        fontSize: 14,
      );
    }

    return SizedBox(
      height: 35 + totalHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                color: isShowTopLine
                    ? const Color.fromRGBO(235, 239, 242, 1)
                    : null,
                width: 1,
                height: 7,
              ),
              customIndicator ??
                  Container(
                    width: indicatorWidth,
                    height: indicatorWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(indicatorWidth * 0.5)),
                        color: indicatorColor),
                  ),
              Expanded(
                child: Container(
                  color: const Color.fromRGBO(235, 239, 242, 1),
                  width: 1,
                ),
              )
            ],
          ),
          const SizedBox(
            width: 7,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      titleWidget,
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                ...children.asMap().entries.map((map) {
                  var element = map.value;
                  return Container(
                    height: itemHeight ?? itemHeights?[map.key],
                    margin: const EdgeInsets.only(bottom: 15),
                    child: element,
                  );
                }).toList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
