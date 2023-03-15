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
          JUITabBar(
            titles: ['1', '2', '3', '4'],
            onTap: (index) {
              return index > 2;
            },
          ),
          JUIButton(
            title: 'title是字符串',
            onPressed: () {},
          ),
          JUIButton(
            child: JUIText(
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
          Row(
            children: [
              JUIButton(
                title: 'badgeValue',
                badgeValue: '',
                badgeHeight: 8,
                tintColor: Colors.redAccent,
                onPressed: () {},
              ),
            ],
          ),
          // FormBuilderRadioGroup<String>(
          //   initialValue: 'Kotlin',
          //   onChanged: (value) {
          //     print(value);
          //   },
          //   activeColor: Color.fromRGBO(129, 216, 208, 1),
          //   // validator: (value) {
          //   //   return '123';
          //   // },
          //   options: ['Dart', 'Kotlin', 'Java', 'Swift', 'Objective-C']
          //       .map((lang) => FormBuilderFieldOption(
          //             value: lang,
          //             child: Text(lang),
          //           ))
          //       .toList(growable: true),
          //   controlAffinity: ControlAffinity.leading,
          // ),
          JUIFormRadioGroup<String>(
            initialValue: 'Kotlin',
            onChanged: (value) {
              print(value);
            },
            activeColor: Color.fromRGBO(129, 216, 208, 1),
            config: JUIFormConfig(title: '123'),
            styleBuilder: (style) {
              style.height = null;
              style.titleHeight = 44;
            },
            options: ['Dart', 'Kotlin', 'Java', 'Swift', 'Objective-C']
                .map((lang) => JUIFormRadioGroupOption(
                      value: lang,
                      child: Text(lang),
                    ))
                .toList(growable: true),
          ),
        ],
      )),
    );
  }
}
