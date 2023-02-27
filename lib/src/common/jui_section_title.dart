import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class JUISectionTitleContainer extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget? titleRightChild;
  final VoidCallback? moreCallbackAction;
  const JUISectionTitleContainer(this.title,
      {required this.child,
      this.moreCallbackAction,
      this.titleRightChild,
      super.key});

  @override
  State<JUISectionTitleContainer> createState() =>
      _JUISectionTitleContainerState();

  static Widget defaultStyle(String title,
      {required Widget child,
      double marginMiddle = 20,
      double bottomPadding = 20,
      VoidCallback? moreCallbackAction,
      Widget? titleRightChild}) {
    return Container(
      padding:
          EdgeInsets.only(top: 20, left: 16, right: 16, bottom: bottomPadding),
      color: Colors.white,
      child: JUISectionTitleContainer(
        title,
        titleRightChild: titleRightChild,
        moreCallbackAction: moreCallbackAction,
        child: Container(
          margin: EdgeInsets.only(top: marginMiddle),
          child: child,
        ),
      ),
    );
  }
}

class _JUISectionTitleContainerState extends State<JUISectionTitleContainer> {
  Widget? titleRightChild;

  @override
  void initState() {
    titleRightChild = widget.titleRightChild;
    if (widget.moreCallbackAction != null) {
      titleRightChild = JUIButton.moreButton(
          onPressed: widget.moreCallbackAction!, title: '查看更多');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(129, 216, 208, 1),
                      borderRadius: BorderRadius.all(Radius.circular(1.5))),
                ),
                const SizedBox(
                  width: 8,
                ),
                JUIText(
                  widget.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(28, 31, 33, 1),
                ),
              ],
            ),
            if (widget.titleRightChild != null) widget.titleRightChild!
          ],
        ),
        widget.child
      ],
    );
  }
}
