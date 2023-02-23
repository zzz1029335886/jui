import 'package:flutter/material.dart';

typedef JUITabBarTitleBuilder = JUITabBarTitle Function(
    BuildContext context, String title, int index, bool isSelected);

class JUITabBarTitle {
  final Widget title;
  final double? width;

  JUITabBarTitle({required this.title, this.width});
}

class JUITabBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? titleLabelStyle;
  final TextStyle? unselectedTitleLabelStyle;
  final bool isScrollable;
  final EdgeInsetsGeometry underLineInsets;
  final BorderSide underLineBorderSide;
  final TabBarIndicatorSize? underIndicatorSize;
  final TabController? tabController;
  final ValueChanged<int>? onTap;
  final List<String> titles;
  final JUITabBarTitleBuilder? headerTitleWidgetBuilder;
  final int selectedIndex;
  final double height;
  final bool hasBottomLine;

  const JUITabBar({
    super.key,
    this.labelColor,
    this.underIndicatorSize,
    this.headerTitleWidgetBuilder,
    this.isScrollable = false,
    this.onTap,
    this.selectedIndex = 0,
    this.height = 49,
    this.hasBottomLine = true,
    required this.tabController,
    this.titleLabelStyle,
    required this.titles,
    this.underLineBorderSide =
        const BorderSide(width: 3, color: Color.fromRGBO(129, 216, 208, 1)),
    this.unselectedTitleLabelStyle,
    this.underLineInsets = EdgeInsets.zero,
    this.unselectedLabelColor,
  });

  static JUITabBar init(
      {required List<String> titles,
      ValueChanged<int>? onTap,
      EdgeInsetsGeometry underLineInsets = EdgeInsets.zero,
      required TabController tabController,
      TextStyle? titleLabelStyle,
      bool isScrollable = false,
      TextStyle? unselectedTitleLabelStyle,
      bool hasBottomLine = true,
      required int selectedIndex}) {
    return JUITabBar(
      labelColor: const Color.fromRGBO(28, 31, 33, 1),
      unselectedLabelColor: const Color.fromRGBO(113, 119, 125, 1),
      titleLabelStyle: titleLabelStyle ??
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      unselectedTitleLabelStyle:
          unselectedTitleLabelStyle ?? const TextStyle(fontSize: 14),
      tabController: tabController,
      onTap: onTap,
      isScrollable: isScrollable,
      underLineInsets: underLineInsets,
      hasBottomLine: hasBottomLine,
      titles: titles,
      selectedIndex: selectedIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = SizedBox(
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            padding: EdgeInsets.zero,
            labelColor: labelColor ?? const Color.fromRGBO(28, 31, 33, 1),
            unselectedLabelColor:
                unselectedLabelColor ?? const Color.fromRGBO(113, 119, 125, 1),
            labelStyle: titleLabelStyle,
            unselectedLabelStyle: unselectedTitleLabelStyle,
            isScrollable: isScrollable,
            indicator: _RoundUnderlineTabIndicator(
                insets: underLineInsets, borderSide: underLineBorderSide),
            indicatorSize: underIndicatorSize,
            controller: tabController,
            onTap: onTap,
            tabs: List.generate(titles.length, (index) {
              var str = titles[index];

              if (headerTitleWidgetBuilder != null) {
                final title = headerTitleWidgetBuilder!(
                    context, str, index, selectedIndex == index);
                return Tab(
                  child: Container(
                      alignment: Alignment.center,
                      width: title.width,
                      child: title.title),
                );
              }

              var tp = TextPainter(
                  textDirection: TextDirection.ltr,
                  text: TextSpan(
                      text: str,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )))
                ..layout();
              return Tab(
                child: Container(
                    alignment: Alignment.center,
                    width: tp.width + 6,
                    child: Text(str)),
              );
            }),
          ),
          if (hasBottomLine)
            const Divider(
              height: 0.5,
            ),
        ],
      ),
    );

    if (isScrollable) {
      return Row(
        children: [widget],
      );
    }

    return widget;
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _RoundUnderlineTabIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const _RoundUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 3.0, color: Colors.red),
    this.insets = EdgeInsets.zero,
  });

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the
  /// tab indicator's bounds in terms of its (centered) tab widget with
  /// [TabIndicatorSize.label], or the entire tab with [TabIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a != null && a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged!);
  }

  // @override
  // _UnderlinePainter createBoxPainter([VoidCallback? onChanged]) {
  //   return _UnderlinePainter(this, onChanged!);
  // }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback onChanged) : super(onChanged);

  final _RoundUnderlineTabIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;
  EdgeInsetsGeometry get insets => decoration.insets;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    //希望的宽度
    double wantWidth = indicator.width;
    //取中间坐标
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(cw - wantWidth / 2,
        indicator.bottom - borderSide.width, wantWidth, borderSide.width);
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator =
        _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
//    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.square;
    // 改为圆角
    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.round;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
