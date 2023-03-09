import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

typedef JUIAutoWarpInputOnEditingComplete = bool? Function(String value);

class JUIAutoWarpInput extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  JUIAutoWarpInput(
      {Key? key,
      this.inputWidth,
      this.textStyle,
      required this.onEditingCompleteText,
      this.content = '',
      this.placeHolder = '请输入',
      this.buttonChild,
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
  final JUIAutoWarpInputOnEditingComplete onEditingCompleteText;
  final String placeHolder;
  final String content;
  final Widget? buttonChild;
  final double? buttonWidth;
  final Color? backgroundColor;
  final double contentBorderRadius;
  final double? contentMinHeight;

  @override
  Widget build(BuildContext context) {
    double buttonWidth = this.buttonWidth ?? 56;
    double inputWidth = this.inputWidth ?? 375 - 16 - buttonWidth;

    return Container(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 0),
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
                  hintStyle: TextStyle(fontSize: 13),
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
                  ? const EdgeInsets.only(bottom: 14)
                  : EdgeInsets.only(bottom: contentMinHeight! - 26.5),
              child: JUIButton(
                child: buttonChild ??
                    const JUIText(
                      '发布',
                      color: Color.fromRGBO(129, 216, 208, 1),
                      fontSize: 14,
                    ),
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
