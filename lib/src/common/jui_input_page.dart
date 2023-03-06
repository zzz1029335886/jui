import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final double? textFieldHeight;

  final bool showMaxLength;
  final bool autofocus;

  final List<TextInputFormatter>? inputFormatters;

  const JUIInputPage(
      {super.key,
      required this.title,
      this.inputFormatters,
      this.tip,
      this.tipTextStyle,
      this.text,
      this.textStyle,
      this.hintText,
      this.hintTextStyle,
      this.maxLength = 9999,
      this.textFieldHeight,
      this.showMaxLength = false,
      this.autofocus = false,
      this.maxLines = 1,
      this.buttonTitle,
      this.onEditingComplete,
      this.isShowCleanButton = true});
  @override
  State<JUIInputPage> createState() => _JUIInputPageState();

  static Future<String?> pushTitleInputPage({
    required BuildContext context,
    required String title,
    String? text,
    String? hintText,
    JUIInputPageOnEditingComplete? onEditingComplete,
  }) {
    return push(
      context: context,
      title: title,
      hintText: hintText,
      tip: '0-10个字符，可由中英文、数字、“_”、“-”组成 ',
      buttonTitle: '确认',
      tipTextStyle: const TextStyle(color: Color.fromRGBO(147, 153, 159, 1)),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[\u4e00-\u9fa5a-zA-Z0-9\-]')),
        LengthLimitingTextInputFormatter(10)
      ],
    );
  }

  static Future<String?> push(
      {required BuildContext context,
      required String title,
      List<TextInputFormatter>? inputFormatters,
      String? text,
      TextStyle? textStyle,
      String? hintText,
      TextStyle? hintTextStyle,
      String? tip,
      TextStyle? tipTextStyle,
      int maxLength = 9999,
      int maxLines = 1,
      double? textFieldHeight,
      bool showMaxLength = false,
      bool autofocus = false,
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
          inputFormatters: inputFormatters,
          autofocus: autofocus,
          showMaxLength: showMaxLength,
          textFieldHeight: textFieldHeight,
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
              height: widget.textFieldHeight,
              padding: EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 5,
                  bottom: widget.showMaxLength ? 16 : 4),
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
                autofocus: widget.autofocus,
                maxLines: widget.maxLines,
                controller: controller,
                inputFormatters: widget.inputFormatters,
                showMaxLength: widget.showMaxLength,
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
