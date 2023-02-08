import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class JUIBasePage extends StatefulWidget {
  const JUIBasePage({super.key});

  @override
  State<JUIBasePage> createState() => _JUIBasePageState();
}

class _JUIBasePageState extends State<JUIBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('基础'),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: JUIText('title'),
            alignment: Alignment.center,
          ),
          JUIButton(
            title: 'title是字符串',
            onPressed: () {},
          ),
          JUIButton(
            text: JUIText(
              'title是widget',
              fontSize: 15,
            ),
            onPressed: () {},
          ),
          JUIButton(
            icon: Icons.abc,
            title: '默认文字在右',
            tintColor: Colors.redAccent,
            onPressed: () {},
          ),
          JUIButton(
            icon: Icons.abc,
            labelPostion: JUIButtonLabelPostion.labelLeft,
            title: '文本在左',
            tintColor: Colors.redAccent,
            middlePadding: 0,
            onPressed: () {},
          ),
          JUIButton(
            icon: Icons.ac_unit_rounded,
            labelPostion: JUIButtonLabelPostion.labelTop,
            title: '文本在上',
            tintColor: Colors.redAccent,
            onPressed: () {},
          ),
          JUIButton(
            icon: Icons.ac_unit_rounded,
            labelPostion: JUIButtonLabelPostion.labelBottom,
            title: '文本在下',
            tintColor: Colors.redAccent,
            onPressed: () {},
          ),
        ],
      )),
    );
  }
}
