import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

import '../list_button.dart';

class TopSheetPage extends StatefulWidget {
  const TopSheetPage({super.key});

  @override
  State<TopSheetPage> createState() => _TopSheetPageState();
}

class _TopSheetPageState extends State<TopSheetPage> {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _button1Key = GlobalKey();
  final GlobalKey _button2Key = GlobalKey();

  final JUIDropdownController _dropdownMenuController = JUIDropdownController();

  @override
  void initState() {
    super.initState();

    _dropdownMenuController.stackKey = _stackKey;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: JUIText('TopSheet'),
        ),
        body: Stack(
          key: _stackKey,
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    itemCount: 10,
                    itemExtent: 44,
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListButton(
                            key: index == 0 ? _button1Key : null,
                            title: 'top_sheet1',
                            onPressed: () {
                              _dropdownMenuController.show(0,
                                  behind: _button1Key);
                            },
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          ListButton(
                            key: index == 0 ? _button2Key : null,
                            title: 'top_sheet2',
                            onPressed: () {
                              _dropdownMenuController.show(1,
                                  behind: _button2Key);
                            },
                          ),
                        ],
                      );
                    })),
            JUIDropdown(
              // controller用于控制menu的显示或隐藏
              controller: _dropdownMenuController,
              // 下拉菜单显示或隐藏动画时长
              animationMilliseconds: 250,

              // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
              builders: [
                JUIDropdownBuilder(
                    dropDownHeight: 40 * 8.0,
                    dropDownWidget: Container(
                      color: Colors.amber,
                    )),
                JUIDropdownBuilder(
                  dropDownHeight: 40 * 8.0,
                  dropDownWidget: Container(
                    color: Colors.redAccent,
                  ),
                ),
                JUIDropdownBuilder(
                  dropDownHeight: 40 * 8.0,
                  dropDownWidget: Container(
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
