import 'package:flutter/material.dart';

import 'jui_auto_warp_input.dart';

typedef JUIBottomInputOnEditingComplete = JUIAutoWarpInputOnEditingComplete;

class JUIBottomInput extends StatelessWidget {
  final JUIBottomInputOnEditingComplete onEditingCompleteText;
  final String? content;
  final String placeHolder;
  final TextStyle textStyle;
  const JUIBottomInput(
      {Key? key,
      required this.onEditingCompleteText,
      this.content,
      this.textStyle = const TextStyle(fontSize: 16),
      this.placeHolder = '请输入内容'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 56;
    double inputWidth = MediaQuery.of(context).size.width - 16 - buttonWidth;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
            child: Container(
              color: Colors.transparent,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )),
          Container(
            color: Colors.white,
            child: JUIAutoWarpInput(
                contentMinHeight: 34,
                contentBorderRadius: 17,
                inputWidth: inputWidth,
                textStyle: textStyle,
                onEditingCompleteText: (value) {
                  bool? res = onEditingCompleteText.call(value);
                  if (res != null && res == true) {
                    Navigator.pop(context);
                  }
                  return res;
                },
                placeHolder: placeHolder,
                buttonWidth: buttonWidth),
          )
        ],
      ),
    );
  }

  static show({
    required BuildContext context,
    required JUIBottomInputOnEditingComplete completeText,
    String? content,
    String placeholder = '请输入内容',
  }) {
    Navigator.push(
        context,
        BottomInputPopupRoute(
            child: JUIBottomInput(
          placeHolder: placeholder,
          content: content,
          onEditingCompleteText: completeText,
        )));
  }
}

//过度路由
class BottomInputPopupRoute extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 250);
  Widget child;

  BottomInputPopupRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
