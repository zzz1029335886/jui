import 'package:flutter/material.dart';

import '../base/jui_button.dart';

typedef JUIInputOnEditingComplete = bool? Function(String value);

class JUIInput extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  JUIInput(
      {Key? key,
      this.inputWidth,
      this.textStyle,
      required this.onEditingCompleteText,
      this.content = '',
      this.placeHolder = '请输入',
      this.buttonWidth,
      this.backgroundColor = const Color.fromRGBO(246, 248, 249, 1),
      this.contentBorderRadius = 5,
      this.contentMinHeight,
      this.autofocus = true})
      : super(key: key) {
    controller.text = content;
  }

  final bool autofocus;
  final double? inputWidth;
  final TextStyle? textStyle;
  final JUIInputOnEditingComplete onEditingCompleteText;
  final String placeHolder;
  final String content;
  final double? buttonWidth;
  final Color? backgroundColor;
  final double contentBorderRadius;
  final double? contentMinHeight;

  @override
  Widget build(BuildContext context) {
    double buttonWidth = this.buttonWidth ?? 56;
    double inputWidth =
        this.inputWidth ?? MediaQuery.of(context).size.width - 16 - buttonWidth;

    return Container(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 0),
        // color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: contentMinHeight == null
                  ? null
                  : BoxConstraints(minHeight: contentMinHeight!),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(contentBorderRadius))),
              width: inputWidth,
              margin: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: controller,
                autofocus: autofocus,
                style: textStyle,
                //设置键盘按钮为发送
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.multiline,
                onEditingComplete: () {
                  //点击发送调用
                  bool? res = onEditingCompleteText(controller.text);
                  if (res != null && res == true) {
                    FocusScope.of(context).unfocus();
                  }
                },
                decoration: InputDecoration(
                  hintText: placeHolder,
                  isDense: true,
                  // fillColor: backgroundColor,
                  contentPadding:
                      EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
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
              height: contentMinHeight,
              margin: contentMinHeight == null
                  ? const EdgeInsets.only(bottom: 12)
                  : EdgeInsets.only(bottom: contentMinHeight! - 28),
              child: JUIButton(
                title: '发送',
                onPressed: () {
                  bool? res = onEditingCompleteText(controller.text);
                  if (res != null && res == true) {
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            )
          ],
        ));
  }
}
