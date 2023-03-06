import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jui/jui.dart';

import '../list_button.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InputPage'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          ListButton(
            title: 'InputPage',
            onPressed: () {
              JUIInputPage.push(
                context: context,
                title: 'title',
                hintText: 'hintText',
                tip: '0-10位字符可由中文,英文,数字及“—”,“-”组成',
                buttonTitle: '确认',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp('[\u4e00-\u9fa5a-zA-Z0-9\-]')),
                  LengthLimitingTextInputFormatter(10)
                ],
                onEditingComplete: (value) {
                  print(value);
                  return Future.sync(() => false);
                },
              );
            },
          ),
        ],
      )),
    );
  }
}
