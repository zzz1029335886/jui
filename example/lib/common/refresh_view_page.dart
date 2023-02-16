import 'package:flutter/material.dart';
import 'package:jieluoxuan_bundle_base/jieluoxuan_bundle_base.dart';
import 'package:jui/jui.dart';

class RefreshPage extends StatefulWidget {
  const RefreshPage({super.key});

  @override
  State<RefreshPage> createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  List<int> list = [1, 2, 3, 4, 5];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('刷新'),
      ),
      body: PagingListWidget(
        dataList: list,
        // action: RequestAction<int>('123'),
        onLoad: (int pageIndex, int pageSize) async {
          List<int> res = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
          await Future.delayed(Duration(seconds: 1));
          return Future(() {
            if (pageIndex == 1) {
              list = res;
            } else {
              list += res;
            }
            setState(() {});

            return res;
          });
        },
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Container(
              height: 44,
              child: JUIText('${index}'),
            );
          },
        ),
      ),
    );
  }
}
