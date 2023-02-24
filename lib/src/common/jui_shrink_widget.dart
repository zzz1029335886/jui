import 'package:flutter/material.dart';

/// 收缩控件
class JUIShrinkWidget extends StatefulWidget {
  //标题位置
  final Widget parent;

  //收缩位置
  final Widget child;

  //收缩位置默认展示视图，默认为空
  final Widget? childVisibleWidget;

  //收缩状态
  final bool isOpen;

  //动画时间 默认0.25秒
  final Duration animateDuration;

  //收缩状态监听
  final Function(bool isOpen, AnimationController shController)? stateListener;

  final Widget? closeTitle;
  final Widget? openTitle;
  final Color? arrowColor;

  const JUIShrinkWidget(
      {Key? key,
      required this.parent,
      required this.child,
      this.animateDuration = const Duration(milliseconds: 250),
      this.isOpen = false,
      this.childVisibleWidget,
      this.stateListener,
      this.closeTitle,
      this.openTitle,
      this.arrowColor})
      : super(key: key);

  @override
  State<JUIShrinkWidget> createState() => _JUIShrinkWidgetState();
}

class _JUIShrinkWidgetState extends State<JUIShrinkWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Animation<double> _shAnimation;
  late AnimationController shController;
  bool isOpen = false;
  @override
  void dispose() {
    shController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isOpen = widget.isOpen;
    shController =
        AnimationController(vsync: this, duration: widget.animateDuration);
    _shAnimation = Tween(begin: .0, end: .5).animate(shController);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (isOpen) {
                shController.reverse();
              } else {
                shController.forward();
              }
              isOpen = !isOpen;
            });
            widget.stateListener?.call(isOpen, shController);
          },
          child: Row(
            children: [
              Expanded(child: widget.parent),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Row(
                  children: [
                    if (widget.openTitle != null || widget.closeTitle != null)
                      isOpen
                          ? widget.openTitle ?? Container()
                          : widget.closeTitle ?? Container(),
                    RotationTransition(
                      turns: _shAnimation,
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: widget.arrowColor ??
                            const Color.fromRGBO(183, 187, 191, 1),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Opacity(
          opacity: isOpen ? 0 : 1,
          child: Container(
            color: const Color.fromRGBO(235, 239, 242, 1),
            height: 0.5,
          ),
        ),
        AnimatedCrossFade(
            firstChild: widget.childVisibleWidget ?? Container(height: 0),
            duration: widget.animateDuration,
            crossFadeState:
                isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            secondChild: widget.child)
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
