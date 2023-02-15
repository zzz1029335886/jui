import 'package:flutter/material.dart';

typedef JUITabBarScrollViewHeaderTitleBuilder = JUITabBarScrollViewTitle
    Function(BuildContext context, String title, int index, bool isSelected);

class JUITabBarScrollViewTitle {
  final Widget title;
  final double? width;

  JUITabBarScrollViewTitle({required this.title, this.width});
}

class JUITabBarScrollView extends StatefulWidget {
  final List<String> titles;
  final TextStyle? titleLabelStyle;
  final TextStyle? unselectedTitleLabelStyle;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final ScrollController? scrollController;

  final IndexedWidgetBuilder bodyWidgetBuilder;
  final JUITabBarScrollViewHeaderTitleBuilder? headerTitleWidgetBuilder;
  final WidgetBuilder? topWidgetBuilder;
  final BorderSide underLineBorderSide;
  final EdgeInsetsGeometry underLineInsets;
  final TabBarIndicatorSize underIndicatorSize;
  final bool isScrollable;

  const JUITabBarScrollView(
      {required this.titles,
      required this.bodyWidgetBuilder,
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
          children: List.generate(widget.titles.length, (index) {
            return widget.bodyWidgetBuilder(context, index);
          })),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          if (widget.topWidgetBuilder != null)
            SliverToBoxAdapter(
              child: widget.topWidgetBuilder!(context),
            ),
          SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  padding: EdgeInsets.zero,
                  labelColor:
                      widget.labelColor ?? const Color.fromRGBO(28, 31, 33, 1),
                  unselectedLabelColor: widget.unselectedLabelColor ??
                      const Color.fromRGBO(113, 119, 125, 1),
                  labelStyle: widget.titleLabelStyle,
                  unselectedLabelStyle: widget.unselectedTitleLabelStyle,
                  isScrollable: widget.isScrollable,
                  indicator: _RoundUnderlineTabIndicator(
                      insets: widget.underLineInsets,
                      borderSide: widget.underLineBorderSide),
                  indicatorSize: widget.underIndicatorSize,
                  controller: _tabController,
                  onTap: _changeTab,
                  tabs: List.generate(widget.titles.length, (index) {
                    var str = widget.titles[index];

                    if (widget.headerTitleWidgetBuilder != null) {
                      final title = widget.headerTitleWidgetBuilder!(
                          context, str, index, _selectedIndex == index);
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
              ),
              pinned: true,
              floating: false),
        ];
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
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
