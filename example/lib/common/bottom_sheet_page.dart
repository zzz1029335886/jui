import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

import '../list_button.dart';

class BottomSheetPage extends StatefulWidget {
  const BottomSheetPage({super.key});

  @override
  State<BottomSheetPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<BottomSheetPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: JUIText('BottomSheet'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ListButton(
              title: 'modal_bottom_sheet',
              onPressed: () {
                JUIBottomSheet.showPageContent(
                    context: context,
                    title: '章节目录',
                    contentBuilder: (context0) {
                      return ListView(
                        shrinkWrap: true,
                        controller: JUIBottomSheet.scrollController(context0),
                        physics: const ClampingScrollPhysics(),
                        children: ListTile.divideTiles(
                            context: context0,
                            tiles: List.generate(
                              100,
                              (index) => ListTile(
                                  title: Text('Item $index'),
                                  onTap: () {
                                    print(index);
                                  }),
                            )).toList(),
                      );
                    });
              },
            ),
            ListButton(
              title: 'selectedTitles',
              onPressed: () {
                JUIBottomSheet.select(
                    context: context, titles: ['1', '2', '3', '4', '5', '6']);
              },
            ),
            // modal_bottom_sheet
          ],
        )),
      ),
    );
  }
}
