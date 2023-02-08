import 'package:example/common/jui_form_page.dart';
import 'package:example/common/jui_shrink_widget_page.dart';
import 'package:example/common/section_title_page.dart';
import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

import '../list_button.dart';
import 'jui_page_container_page.dart';
import 'jui_tabbar_scroll_view_page.dart';

class JUICommonPage extends StatefulWidget {
  const JUICommonPage({super.key});

  @override
  State<JUICommonPage> createState() => _JUICommonPageState();
}

class _JUICommonPageState extends State<JUICommonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: JUIText('Common'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListButton(
            title: 'Form',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return JUIFormPage();
              }));
            },
          ),
          ListButton(
            title: 'ShrinkWidget',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return JUIShrinkWidgetPage();
              }));
            },
          ),
          ListButton(
            title: 'PageContainer',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return JUIPageContainerPage();
              }));
            },
          ),
          ListButton(
            title: 'TabBarScrollViewPage',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return TabBarScrollViewPage();
              }));
            },
          ),
          ListButton(
            title: 'BottomInput',
            onPressed: () {
              JUIBottomInput.show(
                context: context,
                content: '内容',
                placeholder: '123',
                completeText: (value) {
                  print(value);
                },
              );
            },
          ),
          ListButton(
            title: 'SectionTitle',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SectionTitlePage();
              }));
            },
          ),
        ],
      )),
    );
  }
}
