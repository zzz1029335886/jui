import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

typedef JUIInputPageOnEditingComplete = Future<bool>? Function(String? value);

class JUIInputPage extends StatefulWidget {
  final String title;

  final String? text;
  final TextStyle? textStyle;

  final String? hintText;
  final TextStyle? hintTextStyle;

  final String? tip;
  final TextStyle? tipTextStyle;

  final int maxLength;
  final int maxLines;

  final bool isShowCleanButton;

  final JUIInputPageOnEditingComplete? onEditingComplete;

  final String? buttonTitle;

  const JUIInputPage(
      {super.key,
      required this.title,
      this.tip,
      this.tipTextStyle,
      this.text,
      this.textStyle,
      this.hintText,
      this.hintTextStyle,
      this.maxLength = 9999,
      this.maxLines = 1,
      this.buttonTitle,
      this.onEditingComplete,
      this.isShowCleanButton = true});
  @override
  State<JUIInputPage> createState() => _JUIInputPageState();

  static Future<String?> push(
      {required BuildContext context,
      required String title,
      String? text,
      TextStyle? textStyle,
      String? hintText,
      TextStyle? hintTextStyle,
      String? tip,
      TextStyle? tipTextStyle,
      int maxLength = 9999,
      int maxLines = 1,
      String? buttonTitle,
      JUIInputPageOnEditingComplete? onEditingComplete,
      bool isShowCleanButton = true}) {
    Completer<String?> completer = Completer();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return JUIInputPage(
          title: title,
          text: text,
          textStyle: textStyle,
          tip: tip,
          tipTextStyle: tipTextStyle,
          hintText: hintText,
          hintTextStyle: hintTextStyle,
          maxLength: maxLength,
          maxLines: maxLines,
          buttonTitle: buttonTitle,
          onEditingComplete: onEditingComplete,
          isShowCleanButton: isShowCleanButton);
    }));

    return completer.future;
  }
}

class _JUIInputPageState extends State<JUIInputPage> {
  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(7),
                  ),
                  border: Border.all(
                      color: const Color.fromRGBO(235, 239, 242, 1))),
              child: CFTextField(
                text: widget.text,
                textStyle: widget.textStyle ??
                    const TextStyle(
                        fontSize: 14, color: Color.fromRGBO(113, 119, 125, 1)),
                hintText: widget.hintText ?? '请输入',
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                controller: controller,
                isShowCleanButton: widget.isShowCleanButton,
                hintTextStyle: widget.hintTextStyle ??
                    const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(183, 187, 191, 1),
                    ),
                // inputCompletionCallBack: (value, isSubmitted) {
                //   inputCompletionCallBack(value);
                // },
              ),
            ),
            if (widget.tip != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.tip!,
                    style: widget.tipTextStyle,
                  ),
                ],
              ),
            if (widget.buttonTitle != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  JUIButton.themeBackground(
                    title: widget.buttonTitle,
                    onPressed: () {
                      inputCompletionCallBack(controller.text);
                    },
                  ),
                ],
              )
          ],
        ),
      )),
    );
  }

  void inputCompletionCallBack(String? text) {
    var res = widget.onEditingComplete?.call(text);
    if (res != null) {
      res.then((res) {
        if (res == true) {
          Navigator.pop(context);
        }
      });
    } else {
      Navigator.pop(context);
    }
  }
}
