import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

// ignore: must_be_immutable
class JUISectionTitleContainer extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Widget child;
  late Widget? titleRightChild;
  late Widget? leadingTitleChild;
  final VoidCallback? moreCallbackAction;
  JUISectionTitleContainer(
    this.title, {
    required this.child,
    this.titleStyle,
    this.moreCallbackAction,
    this.titleRightChild,
    this.leadingTitleChild,
    super.key,
  }) {
    if (moreCallbackAction != null) {
      titleRightChild =
          JUIButton.moreButton(onPressed: moreCallbackAction!, title: '查看更多');
    }
  }

  static Widget defaultStyle(
    String title, {
    required Widget child,
    double marginMiddle = 20,
    double bottomPadding = 20,
    VoidCallback? moreCallbackAction,
    Widget? titleRightChild,
    Widget? leadingTitleChild,
  }) {
    return Container(
      padding:
          EdgeInsets.only(top: 20, left: 16, right: 16, bottom: bottomPadding),
      color: Colors.white,
      child: JUISectionTitleContainer(
        title,
        titleRightChild: titleRightChild,
        moreCallbackAction: moreCallbackAction,
        leadingTitleChild: leadingTitleChild ?? Container(),
        child: Container(
          margin: EdgeInsets.only(top: marginMiddle),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                leadingTitleChild != null
                    ? leadingTitleChild!
                    : Container(
                        width: 3,
                        height: 16,
                        margin: EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(129, 216, 208, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.5))),
                      ),
                Text(
                  title,
                  style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            if (titleRightChild != null) titleRightChild!
          ],
        ),
        child
      ],
    );
  }
}
