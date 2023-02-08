import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class JUISectionTitleContainer extends StatefulWidget {
  final String title;
  final Widget child;
  final VoidCallback? moreCallbackAction;
  const JUISectionTitleContainer(this.title,
      {required this.child, this.moreCallbackAction, super.key});

  @override
  State<JUISectionTitleContainer> createState() =>
      _JUISectionTitleContainerState();

  static Widget defaultStyle(String title,
      {required Widget child, VoidCallback? moreCallbackAction}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: Colors.white,
      child: JUISectionTitleContainer(
        title,
        moreCallbackAction: moreCallbackAction,
        child: Container(
          child: child,
          margin: EdgeInsets.only(top: 20),
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
                )
              ],
            ),
            if (widget.moreCallbackAction != null)
              JUIButton.moreButton(
                  onPressed: widget.moreCallbackAction!, title: '查看更多')
          ],
        ),
        widget.child
      ],
    );
  }
}
