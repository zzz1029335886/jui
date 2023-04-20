import 'package:flutter/material.dart';

typedef JUIHeaderScrollViewBuilder = PreferredSize Function(
    BuildContext context);

class JUIHeaderScrollViewController extends ChangeNotifier {
  bool canScroll = true;
  void setScroll(bool canScroll) {
    this.canScroll = canScroll;
    notifyListeners();
  }
}

class JUIHeaderScrollView extends StatefulWidget {
  final WidgetBuilder bodyWidgetBuilder;
  final JUIHeaderScrollViewBuilder? headerWidgetBuilder;
  final WidgetBuilder? topWidgetBuilder;
  final ScrollController? scrollController;
  final JUIHeaderScrollViewController? controller;

  /// 是否全屏滚动
  final bool isScrollFullScreen;
  final ScrollPhysics? physics;

  /// 是否固定
  final bool pinned;
  final Key? scrollViewKey;

  const JUIHeaderScrollView(
      {this.headerWidgetBuilder,
      required this.bodyWidgetBuilder,
      this.controller,
      this.scrollController,
      this.physics,
      this.pinned = true,
      this.isScrollFullScreen = true,
      this.topWidgetBuilder,
      this.scrollViewKey,
      super.key});

  @override
  State<JUIHeaderScrollView> createState() => _JUIHeaderScrollViewState();
}

class _JUIHeaderScrollViewState extends State<JUIHeaderScrollView> {
  int id = 0;
  bool canScroll = true;
  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(controllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(controllerListener);
  }

  void controllerListener() {
    setState(() {
      canScroll = widget.controller?.canScroll ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollPhysics? physics = widget.physics ??
        (canScroll ? null : const NeverScrollableScrollPhysics());

    if (widget.isScrollFullScreen) {
      Widget widget0 = widget.bodyWidgetBuilder(context);
      bool isSliver = widget0 is SliverToBoxAdapter || widget0 is SliverList;
      return CustomScrollView(
        key: widget.scrollViewKey,
        controller: widget.scrollController,
        physics: physics,
        slivers: [
          if (widget.topWidgetBuilder != null)
            SliverToBoxAdapter(
              child: widget.topWidgetBuilder!(context),
            ),
          if (widget.headerWidgetBuilder != null)
            SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  widget.headerWidgetBuilder!(context),
                ),
                pinned: widget.pinned,
                floating: false),
          if (isSliver) widget0,
          if (!isSliver)
            SliverToBoxAdapter(
              child: widget0,
            ),
        ],
      );
    }

    return NestedScrollView(
      key: widget.scrollViewKey,
      body: widget.bodyWidgetBuilder(context),
      controller: widget.scrollController,
      physics: physics,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          if (widget.topWidgetBuilder != null)
            SliverToBoxAdapter(
              child: widget.topWidgetBuilder!(context),
            ),
          if (widget.headerWidgetBuilder != null)
            SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  widget.headerWidgetBuilder!(context),
                ),
                pinned: widget.pinned,
                floating: true),
        ];
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._content);

  final PreferredSize _content;

  @override
  double get minExtent => _content.preferredSize.height;
  @override
  double get maxExtent => _content.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _content;
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
