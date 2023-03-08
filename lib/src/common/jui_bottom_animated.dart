import 'package:flutter/material.dart';

class JUIBottomAnimated extends StatelessWidget {
  const JUIBottomAnimated(
      {Key? key, this.controller, required this.child, required this.height})
      : super(key: key);

  final Animation<double>? controller;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return contentWidget();
    }

    Animation<double> animation =
        Tween<double>(begin: height, end: 0).animate(controller!);
    Animation<double> sizeAnimation =
        Tween<double>(begin: 0, end: 1).animate(controller!);

    return SizeTransition(
      axisAlignment: 1,
      sizeFactor: sizeAnimation,
      child: AnimatedBuilder(
        builder: (context, child) {
          return Transform.translate(
              offset: Offset(0, animation.value), child: child);
        },
        animation: animation,
        child: contentWidget(),
      ),
    );
  }

  Widget contentWidget() {
    return child;
  }
}
