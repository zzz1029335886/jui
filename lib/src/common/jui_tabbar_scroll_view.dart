import 'package:flutter/material.dart';

import '../../jui.dart';
import '../base/jui_tab_bar.dart';

typedef JUITabBarScrollViewHeaderTitleBuilder = JUITabBarTitleBuilder;
typedef JUITabBarScrollViewTitle = JUITabBarTitle;

typedef JUITabBarScrollViewHeaderContainer = Widget Function(
    PreferredSizeWidget sizeWidget);

typedef JUITabBarScrollViewSliversBuilder = JUITabBarScrollViewSliver Function(
    BuildContext context, int index);

class JUITabBarScrollViewSliver {
  final List<Widget> slivers;
  final ScrollController? scrollController;
  final bool isPageStorage;
  final TransitionBuilder? builder;
  final Widget? fixedHeaderWidget;
  const JUITabBarScrollViewSliver(
      {required this.slivers,
      this.builder,
      this.fixedHeaderWidget,
      this.scrollController,
      this.isPageStorage = true});
}

class JUITabBarScrollView extends StatefulWidget {
  final List<String> titles;
  final List<Widget>? widgets;
  final JUITabBarScrollViewSliversBuilder? sliversBuilder;
  final ScrollController? sliverScrollController;

  final TextStyle? titleLabelStyle;
  final TextStyle? unselectedTitleLabelStyle;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final ScrollController? scrollController;
  final TabController? tabController;

  final IndexedWidgetBuilder? bodyWidgetBuilder;
  final JUITabBarScrollViewHeaderTitleBuilder? headerTitleWidgetBuilder;
  final WidgetBuilder? topWidgetBuilder;
  final BorderSide underLineBorderSide;
  final EdgeInsetsGeometry underLineInsets;
  final TabBarIndicatorSize underIndicatorSize;
  final bool isScrollable;
  final Decoration? headerDecoration;
  final JUITabBarScrollViewHeaderContainer? headerContainer;
  final bool? Function(int index)? tabBarOnTap;
  final double titleExtraWidth;
  final EdgeInsetsGeometry titlePadding;
  final bool isBodyScrollable;

  const JUITabBarScrollView(
      {required this.titles,
      this.tabBarOnTap,
      this.bodyWidgetBuilder,
      this.headerDecoration,
      this.headerContainer,
      this.widgets,
      this.sliversBuilder,
      this.sliverScrollController,
      this.scrollController,
      this.tabController,
      this.headerTitleWidgetBuilder,
      this.labelColor,
      this.isBodyScrollable = true,
      this.unselectedLabelColor,
      this.titleLabelStyle,
      this.titleExtraWidth = 6,
      this.titlePadding = const EdgeInsets.symmetric(horizontal: 16),
      this.unselectedTitleLabelStyle,
      this.underLineBorderSide =
          const BorderSide(width: 3, color: Color.fromRGBO(129, 216, 208, 1)),
      this.isScrollable = false,
      this.underLineInsets =
          const EdgeInsets.only(left: 8, right: 8, bottom: 5),
      this.underIndicatorSize = TabBarIndicatorSize.label,
      this.topWidgetBuilder,
      super.key});

  static Widget defaultStyle(
      {required List<String> titles,
      List<Widget>? widgets,
      ScrollController? scrollController,
      ScrollController? sliverScrollController,
      bool isScrollable = false,
      bool isBodyScrollable = true,
      bool? Function(int index)? tabBarOnTap,
      JUITabBarScrollViewSliversBuilder? sliversBuilder,
      double titleExtraWidth = 6,
      EdgeInsets titlePadding = const EdgeInsets.symmetric(horizontal: 16),
      WidgetBuilder? topWidgetBuilder}) {
    return JUITabBarScrollView(
      titleLabelStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      unselectedTitleLabelStyle: const TextStyle(fontSize: 14),
      titles: titles,
      isScrollable: isScrollable,
      isBodyScrollable: isBodyScrollable,
      sliverScrollController: sliverScrollController,
      sliversBuilder: sliversBuilder,
      titleExtraWidth: titleExtraWidth,
      titlePadding: titlePadding,
      tabBarOnTap: tabBarOnTap,
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

    _tabController = widget.tabController ??
        TabController(vsync: this, length: widget.titles.length);
    //   _tabController.addListener(() {
    //     _changeTab(_tabController.index);
    //   });
    // }

    // void _changeTab(int index) {
    //   widget.tabBarClick?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget>? children;
    if (widget.sliversBuilder != null) {
      children = List.generate(widget.titles.length, (index) {
        var sliverRes = widget.sliversBuilder!.call(context, index);

        Widget scrollView = CustomScrollView(
          key: sliverRes.isPageStorage ? PageStorageKey(index) : null,
          slivers: [
            // const SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 44,
            //   ),
            // ),
            ...sliverRes.slivers
          ],
          controller: sliverRes.scrollController,
        );

        if (sliverRes.builder != null) {
          scrollView = sliverRes.builder!(context, scrollView);
        }

        return Container(
          padding: const EdgeInsets.only(top: 49),
          child: Column(
            children: [
              if (sliverRes.fixedHeaderWidget != null)
                sliverRes.fixedHeaderWidget!,
              Expanded(
                child: scrollView,
              ),
            ],
          ),
        );
      });
    }

    return NestedScrollView(
      controller: widget.scrollController,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      body: TabBarView(
          controller: _tabController,
          physics: !widget.isBodyScrollable
              ? const NeverScrollableScrollPhysics()
              : null,
          children: children ??
              widget.widgets ??
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
          if (widget.sliversBuilder != null)
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: headerWidget(),
            ),
          if (widget.sliversBuilder == null) headerWidget(),
          // headerWidget(),
        ];
      },
    );
  }

  Widget headerWidget() {
    return SliverPersistentHeader(
        delegate: _SliverAppBarDelegate(
            JUITabBar(
              labelColor:
                  widget.labelColor ?? const Color.fromRGBO(28, 31, 33, 1),
              unselectedLabelColor: widget.unselectedLabelColor ??
                  const Color.fromRGBO(113, 119, 125, 1),
              titleExtraWidth: widget.titleExtraWidth,
              titlePadding: widget.titlePadding,
              titleLabelStyle: widget.titleLabelStyle,
              unselectedTitleLabelStyle: widget.unselectedTitleLabelStyle,
              isScrollable: widget.isScrollable,
              underLineInsets: widget.underLineInsets,
              underLineBorderSide: widget.underLineBorderSide,
              underIndicatorSize: widget.underIndicatorSize,
              tabController: _tabController,
              onTap: widget.tabBarOnTap,
              titles: widget.titles,
              headerTitleWidgetBuilder: widget.headerTitleWidgetBuilder,
            ),
            headerContainer: widget.headerContainer,
            decoration: widget.headerDecoration),
        pinned: true,
        floating: false);
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
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
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
