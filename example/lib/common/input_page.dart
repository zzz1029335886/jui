import 'package:flutter/material.dart';
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
                tip: 'tip',
                buttonTitle: '确认',
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
