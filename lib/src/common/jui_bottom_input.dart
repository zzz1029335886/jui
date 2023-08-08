import 'package:flutter/material.dart';

import 'jui_auto_warp_input.dart';

typedef JUIBottomInputOnEditingComplete = JUIAutoWarpInputOnEditingComplete;

class JUIBottomInput extends StatelessWidget {
  final JUIBottomInputOnEditingComplete onEditingCompleteText;
  final String? content;
  final String placeHolder;
  final TextStyle textStyle;
  final double? height;
  final int maxLine;
  final int minLine;
  final int maxLength;
  final bool showMaxLength;

  const JUIBottomInput(
      {Key? key,
      required this.onEditingCompleteText,
      this.content,
      this.maxLine = 5,
      this.minLine = 1,
      this.maxLength = 9999,
      this.showMaxLength = false,
      this.height,
      this.textStyle = const TextStyle(fontSize: 16),
      this.placeHolder = '请输入内容'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 56;
    double inputWidth = 375 - 16 - buttonWidth;
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
            color: Theme.of(context).primaryColorDark,
            child: JUIAutoWarpInput(
                contentMinHeight: height ?? 34,
                maxLines: maxLine,
                minLines: minLine,
                maxLength: maxLength,
                showMaxLength: showMaxLength,
                contentBorderRadius: 17,
                inputWidth: inputWidth,
                textStyle: textStyle,
                onEditingCompleteText: (value) async {
                  bool? res = await onEditingCompleteText.call(value);
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
    double? height,
    int maxLine = 5,
    int minLine = 1,
    int maxLength = 9999,
    bool showMaxLength = false,
    String placeholder = '请输入内容',
  }) {
    Navigator.push(
        context,
        BottomInputPopupRoute(
            child: JUIBottomInput(
          height: height,
          maxLine: maxLine,
          minLine: minLine,
          maxLength: maxLength,
          showMaxLength: showMaxLength,
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
