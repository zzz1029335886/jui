import 'package:example/common/input_page.dart';
import 'package:example/common/jui_form_page.dart';
import 'package:example/common/jui_header_scroll_view_page.dart';
import 'package:example/common/jui_shrink_widget_page.dart';
import 'package:example/common/scroll_view_page.dart';
import 'package:example/common/section_title_page.dart';
import 'package:example/common/top_sheet_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

import '../list_button.dart';
import 'gridview_page.dart';
import 'jui_page_container_page.dart';
import 'jui_tabbar_scroll_view_page.dart';
import 'refresh_view_page.dart';
import 'tab_bar_page.dart';

class JUICommonPage extends StatefulWidget {
  const JUICommonPage({super.key});

  @override
  State<JUICommonPage> createState() => _JUICommonPageState();
}

class _JUICommonPageState extends State<JUICommonPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: JUIText('Common'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ListButton(
              title: 'Form',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return JUIFormPage();
                }));
              },
            ),
            ListButton(
              title: 'ShrinkWidget',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return JUIShrinkWidgetPage();
                }));
              },
            ),
            ListButton(
              title: 'PageContainer',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return JUIPageContainerPage();
                }));
              },
            ),
            ListButton(
              title: 'TabBarScrollViewPage',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TabBarScrollViewPage();
                }));
              },
            ),
            ListButton(
              title: 'TabBar',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TabBarPage();
                }));
              },
            ),
            ListButton(
              title: 'HeaderScrollViewPage',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return HeaderScrollViewPage();
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
                Navigator.of(context).push(
                  CupertinoPageRoute(
                      builder: (context) {
                        return SectionTitlePage();
                      },
                      fullscreenDialog: true),
                );
              },
            ),
            ListButton(
              title: 'ScrollViewExtension',
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                      builder: (context) {
                        return ScrollViewPage();
                      },
                      fullscreenDialog: false),
                );
              },
            ),
            ListButton(
              title: 'bottomSheet',
              onPressed: () {
                Navigator.of(context).pushNamed('/bottom_sheet');
              },
            ),

            ListButton(
              title: 'topSheet',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TopSheetPage();
                }));
              },
            ),

            ListButton(
                title: 'Share',
                onPressed: () {
                  JUIShare.sheetShow(context: context);
                }),

            ListButton(
                title: 'GridPhotoViewer',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return GridPhotoViewer();
                  }));
                }),

            ListButton(
                title: 'Picker',
                onPressed: () {
                  JUIPicker.showStringPicker(
                    context,
                    selectIndex: 2,
                    data: ['明细', '类目', '培训费', '类目', '明细'],
                    clickCallBack: (selectValue, selectIndexArr) {
                      print(selectValue);
                      print(selectIndexArr);
                    },
                  );
                }),

            ListButton(
                title: 'Refresh',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return RefreshPage();
                  }));
                }),
            ListButton(
                title: 'InputPage',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return InputPage();
                  }));
                }),

            // modal_bottom_sheet
          ],
        )),
      ),
    );
  }
}
