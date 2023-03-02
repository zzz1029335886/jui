import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jui/jui.dart';

class JUIFormPage extends StatefulWidget {
  @override
  _JUIFormPageState createState() => _JUIFormPageState();
}

class _JUIFormPageState extends State<JUIFormPage> {
  // bool _switchSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("From")),
        body: Scrollbar(
            child: SingleChildScrollView(
                child: JUIFormBuilder(
          style: JUIFormStyle(titleWidth: 100),
          child: Column(
            children: <Widget>[
              JUIFormInput(
                minHeight: 44,
                maxHeight: 160,
                contentDecoration: BoxDecoration(
                  color: Colors.amber,
                ),
                hintText: '最小高度和titleHeight一致',
                hintTextStyle: TextStyle(color: Colors.white, fontSize: 14),
                contentPadding: EdgeInsets.all(3),
                valueChanged: (value) {
                  print(value);
                },
              ),
              JUIFormInput(
                content: '15551529399',
                keyboardType: TextInputType.phone,
                hintText: '请输入手机号',
                maxLines: 1,
                isShowCleanButton: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  LengthLimitingTextInputFormatter(11)
                ],
                config: JUIFormConfig(
                  title: '输入手机号',
                ),
                style: JUIFormStyle(
                  titleHeight: 44,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              JUIFormSelect(
                content: "选择",
                clickCallback: () {
                  print(123);
                },
                config: JUIFormConfig(
                  title: '选择框',
                ),
                style: JUIFormStyle(
                  height: 44,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              JUIFormCustom(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('自定义的内容0'),
                    Text(
                      '自定义的内容1',
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
                config: JUIFormConfig(
                  title: '自定义',
                ),
                style: JUIFormStyle(
                  height: 61,
                  titleHeight: 44,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              JUIFormInput(
                content:
                    "12345r is a good place to start if you want to get a good idea of what you want to ",
                minHeight: 66,
                maxHeight: 138,
                hintText: '请输入您的需求，需求尽量详细，以便更精确地匹配到合适您的项目',
                contentPadding: EdgeInsets.only(left: 8, right: 8, top: 2),
                contentDecoration: BoxDecoration(
                    color: Color.fromRGBO(246, 248, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                config: JUIFormConfig(
                  title: "title在上",
                ),
                style: JUIFormStyle(
                  titleHeight: 44,
                  // isTopTitle: true,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                ),
              ),
              JUIFormCustom(
                CupertinoSwitch(
                  value: true,
                  onChanged: (value) {
                    print(value);
                  },
                ),
                config: JUIFormConfig(
                    icon: Icon(
                      Icons.abc,
                    ),
                    isShowRedStar: true,
                    title: '带图标自定义之Switch',
                    tip: '这是tip',
                    tipBgColor: Colors.amber),
                style: JUIFormStyle(
                  height: 44,
                  titleWidth: 180,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                ),
              ),
            ],
          ),
        ))));
  }
}
