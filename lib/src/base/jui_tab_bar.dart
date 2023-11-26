import 'package:flutter/material.dart';
import 'package:jui/src/extension/jui_extension.dart';
import 'changed_system_tabs.dart' as cst;

typedef JUITabBarTitleBuilder = JUITabBarTitle Function(
    BuildContext context, String title, int index, bool isSelected);

class JUITabBarTitle {
  final Widget title;
  final double? width;

  JUITabBarTitle({required this.title, this.width});

  static double textWidth(String text,
      {TextStyle style = const TextStyle(
        fontSize: 16,
        fontWeight: JUIFontWeightExtension.medium,
      )}) {
    var tp = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style))
      ..layout();

    return tp.width;
  }
}

class JUITabBar extends StatefulWidget implements PreferredSizeWidget {
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? titleLabelStyle;
  final TextStyle? unselectedTitleLabelStyle;
  final bool isScrollable;
  final EdgeInsetsGeometry underLineInsets;
  final BorderSide underLineBorderSide;
  final TabBarIndicatorSize? underIndicatorSize;
  final TabController? tabController;
  final bool? Function(int index)? onTap;
  final List<String> titles;
  final JUITabBarTitleBuilder? headerTitleWidgetBuilder;
  final int selectedIndex;
  final double height;
  final double titleExtraWidth;
  final bool hasBottomLine;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry padding;

  const JUITabBar({
    super.key,
    this.labelColor,
    this.padding = EdgeInsets.zero,
    this.titleExtraWidth = 6,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 16),
    this.underIndicatorSize,
    this.headerTitleWidgetBuilder,
    this.isScrollable = false,
    this.onTap,
    this.selectedIndex = 0,
    this.height = 49,
    this.hasBottomLine = true,
    this.tabController,
    this.titleLabelStyle = const TextStyle(
        fontSize: 16, fontWeight: JUIFontWeightExtension.medium),
    required this.titles,
    this.underLineBorderSide =
        const BorderSide(width: 3, color: Color.fromRGBO(129, 216, 208, 1)),
    this.unselectedTitleLabelStyle = const TextStyle(fontSize: 14),
    this.underLineInsets = const EdgeInsets.only(bottom: 5),
    this.unselectedLabelColor,
  });

  static JUITabBar init(
      {required List<String> titles,
      bool? Function(int index)? onTap,
      EdgeInsetsGeometry underLineInsets = const EdgeInsets.only(bottom: 5),
      TabController? tabController,
      JUITabBarTitleBuilder? headerTitleWidgetBuilder,
      TextStyle? titleLabelStyle,
      bool isScrollable = false,
      TextStyle? unselectedTitleLabelStyle,
      bool hasBottomLine = true,
      double titleExtraWidth = 6,
      EdgeInsets titlePadding = const EdgeInsets.symmetric(horizontal: 16),
      required int selectedIndex}) {
    return JUITabBar(
      unselectedLabelColor: const Color.fromRGBO(113, 119, 125, 1),
      titleLabelStyle: titleLabelStyle ??
          const TextStyle(
              fontSize: 16, fontWeight: JUIFontWeightExtension.medium),
      unselectedTitleLabelStyle:
          unselectedTitleLabelStyle ?? const TextStyle(fontSize: 14),
      tabController: tabController,
      headerTitleWidgetBuilder: headerTitleWidgetBuilder,
      onTap: onTap,
      isScrollable: isScrollable,
      underLineInsets: underLineInsets,
      hasBottomLine: hasBottomLine,
      titleExtraWidth: titleExtraWidth,
      titlePadding: titlePadding,
      titles: titles,
      selectedIndex: selectedIndex,
    );
  }

  @override
  State<JUITabBar> createState() => _JUITabBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _JUITabBarState extends State<JUITabBar> with TickerProviderStateMixin {
  int selectedIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    tabController = widget.tabController ??
        TabController(length: widget.titles.length, vsync: this);
    selectedIndex = widget.selectedIndex;

    if (widget.headerTitleWidgetBuilder != null) {
      tabController.addListener(() {
        _onTap(tabController.index);
      });
    }

    super.initState();
  }

  void _onTap(value) {
    bool? res = widget.onTap?.call(value);
    if (res == false) {
      tabController.animateTo(selectedIndex);
      // setState(() {
      //   selectedIndex = selectedIndex;
      // });
      return;
    }

    if (selectedIndex == value) {
      return;
    }
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = SizedBox(
      height: this.widget.height,
      child: Stack(
        children: [
          cst.TabBar(
            padding: this.widget.padding,
            labelPadding: this.widget.titlePadding,
            labelColor: this.widget.labelColor,
            unselectedLabelColor: this.widget.unselectedLabelColor ??
                const Color.fromRGBO(113, 119, 125, 1),
            labelStyle: this.widget.titleLabelStyle,
            unselectedLabelStyle: this.widget.unselectedTitleLabelStyle,
            isScrollable: this.widget.isScrollable,
            indicator: _RoundUnderlineTabIndicator(
                insets: this.widget.underLineInsets,
                borderSide: this.widget.underLineBorderSide),
            indicatorSize: this.widget.underIndicatorSize,
            controller: tabController,
            onTap: _onTap,
            tabs: List.generate(this.widget.titles.length, (index) {
              var str = this.widget.titles[index];

              if (this.widget.headerTitleWidgetBuilder != null) {
                final title = this.widget.headerTitleWidgetBuilder!(
                    context, str, index, selectedIndex == index);
                return Tab(
                  child: SizedBox(
                    width: title.width,
                    child: Center(
                      child: title.title,
                    ),
                  ),
                );
              }

              return Tab(
                child: Container(alignment: Alignment.center, child: Text(str)),
              );
            }),
          ),
          if (this.widget.hasBottomLine)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Divider(
                height: 1,
              ),
            ),
        ],
      ),
    );

    if (this.widget.isScrollable) {
      return SingleChildScrollView(
        child: widget,
      );
    }

    return widget;
  }
}

class _RoundUnderlineTabIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const _RoundUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 3.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  });

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the tab
  /// indicator's bounds in terms of its (centered) tab widget with
  /// [TabBarIndicatorSize.label], or the entire tab with
  /// [TabBarIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is UnderlineTabIndicator) {
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
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    // return Rect.fromLTWH(
    //   indicator.left,
    //   indicator.bottom - borderSide.width,
    //   indicator.width,
    //   borderSide.width,
    // );
    double wantWidth = 20;
    double cw = (indicator.left + indicator.right) * 0.5;
    return Rect.fromLTWH(cw - wantWidth * 0.5,
        indicator.bottom - borderSide.width, wantWidth, borderSide.width);
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  final _RoundUnderlineTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
