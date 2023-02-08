import 'package:flutter/material.dart';

import '../base/jui_base.dart';

class JUIBottomInput extends StatelessWidget {
  final ValueChanged onEditingCompleteText;
  final TextEditingController controller = TextEditingController();
  final String? content;
  final String placeHolder;
  final TextStyle textStyle;
  JUIBottomInput(
      {Key? key,
      required this.onEditingCompleteText,
      this.content,
      this.textStyle = const TextStyle(fontSize: 16),
      this.placeHolder = '请输入内容'})
      : super(key: key) {
    controller.text = content ?? '';
  }

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
              padding:
                  const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 0),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 209, 209, 205)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    width: inputWidth,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      style: textStyle,
                      //设置键盘按钮为发送
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.multiline,
                      onEditingComplete: () {
                        //点击发送调用
                        onEditingCompleteText(controller.text);
                        Navigator.pop(context);
                      },
                      decoration: InputDecoration(
                        hintText: placeHolder,
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                            left: 10, top: 5, bottom: 5, right: 10),
                        border: OutlineInputBorder(
                          gapPadding: 0,
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),

                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  Container(
                    width: buttonWidth,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: JUIButton(
                      title: '发送',
                      onPressed: () {
                        onEditingCompleteText(controller.text);
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  static show({
    required BuildContext context,
    required ValueChanged completeText,
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
