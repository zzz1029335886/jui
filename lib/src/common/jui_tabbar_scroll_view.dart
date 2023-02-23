import 'package:flutter/material.dart';

import '../base/jui_tab_bar.dart';

typedef JUITabBarScrollViewHeaderTitleBuilder = JUITabBarTitleBuilder;
typedef JUITabBarScrollViewTitle = JUITabBarTitle;

typedef JUITabBarScrollViewHeaderContainer = Widget Function(
    PreferredSizeWidget sizeWidget);

class JUITabBarScrollView extends StatefulWidget {
  final List<String> titles;
  final List<Widget>? widgets;
  final TextStyle? titleLabelStyle;
  final TextStyle? unselectedTitleLabelStyle;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final ScrollController? scrollController;

  final IndexedWidgetBuilder? bodyWidgetBuilder;
  final JUITabBarScrollViewHeaderTitleBuilder? headerTitleWidgetBuilder;
  final WidgetBuilder? topWidgetBuilder;
  final BorderSide underLineBorderSide;
  final EdgeInsetsGeometry underLineInsets;
  final TabBarIndicatorSize underIndicatorSize;
  final bool isScrollable;
  final Decoration? headerDecoration;
  final JUITabBarScrollViewHeaderContainer? headerContainer;

  const JUITabBarScrollView(
      {required this.titles,
      this.bodyWidgetBuilder,
      this.headerDecoration,
      this.headerContainer,
      this.widgets,
      this.scrollController,
      this.headerTitleWidgetBuilder,
      this.labelColor,
      this.unselectedLabelColor,
      this.titleLabelStyle,
      this.unselectedTitleLabelStyle,
      this.underLineBorderSide =
          const BorderSide(width: 3, color: Color.fromRGBO(129, 216, 208, 1)),
      this.isScrollable = false,
      this.underLineInsets = const EdgeInsets.symmetric(horizontal: 8),
      this.underIndicatorSize = TabBarIndicatorSize.label,
      this.topWidgetBuilder,
      super.key});

  static Widget defaultStyle(
      {required List<String> titles,
      required List<Widget> widgets,
      ScrollController? scrollController,
      WidgetBuilder? topWidgetBuilder}) {
    return JUITabBarScrollView(
      titleLabelStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      unselectedTitleLabelStyle: const TextStyle(fontSize: 14),
      titles: titles,
      scrollController: scrollController,
      topWidgetBuilder: topWidgetBuilder,
      widgets: widgets,
    );
  }

  @override
  State<JUITabBarScrollView> createState() => _JUITabBarScrollViewState();
}

class _JUITabBarScrollViewState extends State<JUITabBarScrollView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  int id = 0;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: widget.titles.length);
    _tabController.addListener(() {
      _changeTab(_tabController.index);
    });
  }

  int _selectedIndex = 0;
  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: widget.scrollController,
      body: TabBarView(
          controller: _tabController,
          children: widget.widgets ??
              List.generate(widget.titles.length, (index) {
                return widget.bodyWidgetBuilder?.call(context, index) ??
                    Container();
              })),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          if (widget.topWidgetBuilder != null)
            SliverToBoxAdapter(
              child: widget.topWidgetBuilder!(context),
            ),
          SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                  JUITabBar(
                    labelColor: widget.labelColor ??
                        const Color.fromRGBO(28, 31, 33, 1),
                    unselectedLabelColor: widget.unselectedLabelColor ??
                        const Color.fromRGBO(113, 119, 125, 1),
                    titleLabelStyle: widget.titleLabelStyle,
                    unselectedTitleLabelStyle: widget.unselectedTitleLabelStyle,
                    isScrollable: widget.isScrollable,
                    underLineInsets: widget.underLineInsets,
                    underLineBorderSide: widget.underLineBorderSide,
                    underIndicatorSize: widget.underIndicatorSize,
                    tabController: _tabController,
                    onTap: _changeTab,
                    titles: widget.titles,
                    selectedIndex: _selectedIndex,
                    headerTitleWidgetBuilder: widget.headerTitleWidgetBuilder,
                  ),
                  headerContainer: widget.headerContainer,
                  decoration: widget.headerDecoration),
              pinned: true,
              floating: false),
        ];
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.sizeWidget,
      {this.decoration, this.headerContainer});
  final JUITabBarScrollViewHeaderContainer? headerContainer;
  final PreferredSizeWidget sizeWidget;
  final Decoration? decoration;

  @override
  double get minExtent => sizeWidget.preferredSize.height;
  @override
  double get maxExtent => sizeWidget.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (headerContainer != null) {
      var container = headerContainer!(sizeWidget);
      return Container(
        color: decoration == null ? Colors.white : null,
        decoration: decoration,
        child: container,
      );
    }
    return Container(
      color: decoration == null ? Colors.white : null,
      decoration: decoration,
      child: sizeWidget,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
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
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
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
