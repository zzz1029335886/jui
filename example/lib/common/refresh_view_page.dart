import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class RefreshPage extends StatefulWidget {
  const RefreshPage({super.key});

  @override
  State<RefreshPage> createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  ScrollController scrollController = ScrollController();
  List<int> list = [1, 2, 3, 4, 5];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('刷新'),
      ),
      body: PagingListWidget(
        controller: scrollController,
        dataList: list,
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
        child: Column(
          children: [
            Container(
              height: 100,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Row(
                    children: List.generate(
                      10,
                      (index) => JUIText(
                          '1.新增scrollController滚动到指定子空间位置，详情见example Common下scrollView Extension. 2.tabbarScrollView 新增slivers 并且可以保持状态.1.新增scrollController滚动到指定子空间位置，详情见example Common下scrollView Extension. 2.tabbarScrollView 新增slivers 并且可以保持状态.1.新增scrollController滚动到指定子空间位置，详情见example Common下scrollView Extension. 2.tabbarScrollView 新增slivers 并且可以保持状态.'),
                    ),
                  )),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 44,
                    child: JUIText('${index}'),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
