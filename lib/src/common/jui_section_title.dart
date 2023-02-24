import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class JUISectionTitleContainer extends StatefulWidget {
  final String title;
  final Widget child;
  Widget? titleRightChild;
  JUISectionTitleContainer(this.title,
      {required this.child,
      VoidCallback? moreCallbackAction,
      this.titleRightChild,
      super.key}) {
    if (moreCallbackAction != null) {
      var titleRightChild =
          JUIButton.moreButton(onPressed: moreCallbackAction, title: '查看更多');
      this.titleRightChild = titleRightChild;
    }
  }

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
          child: child,
          margin: EdgeInsets.only(top: marginMiddle),
        ),
      ),
    );
  }
}

class _JUISectionTitleContainerState extends State<JUISectionTitleContainer> {
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
