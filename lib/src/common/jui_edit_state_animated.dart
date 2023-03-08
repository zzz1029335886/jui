import 'package:flutter/material.dart';

// ignore: must_be_immutable
class JUIEditStateAnimated extends StatelessWidget {
  JUIEditStateAnimated(
      {super.key,
      this.controller,
      required this.child,
      required this.isSelected,
      this.selectedIcon,
      this.unselectedIcon}) {
    if (controller != null) {
      animation = Tween<double>(begin: -16, end: 16).animate(controller!);
    } else {
      animation = null;
    }
  }

  final Widget? unselectedIcon;
  final Widget? selectedIcon;
  final Animation<double>? controller;
  late Animation<double>? animation;
  final Widget child;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (animation == null) {
      return Transform.translate(
          offset: const Offset(16, 0),
          child: Container(
            padding: const EdgeInsets.only(right: 32),
            child: contentWidget(),
          ));
    }

    return ClipRect(
      child: AnimatedBuilder(
        animation: animation!,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
              offset: Offset(animation!.value, 0), child: child);
        },
        child: contentWidget(),
      ),
    );
  }

  Row contentWidget() {
    return Row(
      children: [
        if (isSelected)
          selectedIcon ??
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 16,
                color: Color.fromRGBO(129, 216, 208, 1),
              ),
        if (!isSelected)
          unselectedIcon ??
              const Icon(
                Icons.circle_outlined,
                size: 16,
                color: Color.fromRGBO(183, 187, 191, 1),
              ),
        const SizedBox(
          width: 16,
        ),
        Expanded(child: child),
      ],
    );
  }
}
