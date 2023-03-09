import 'package:example/pages/alive_page1.dart';
import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class TabBarScrollViewPage extends StatefulWidget {
  const TabBarScrollViewPage({super.key});

  @override
  State<TabBarScrollViewPage> createState() => _TabBarScrollViewPageState();
}

class _TabBarScrollViewPageState extends State<TabBarScrollViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: JUITabBarScrollView.defaultStyle(
          isBodyScrollable: false,
          tabBarOnTap: (index) {
            print(index);
            return index % 2 == 0;
          },
          titles: ['训练营', '直播', '课程'],

          // isScrollable: true,
          // labelColor: Colors.amber,
          // unselectedLabelColor: Colors.black,

          // headerTitleWidgetBuilder: (context, title, index, isSelected) {
          //   return JUITabBarScrollViewTitle(
          //       title: Row(
          //     children: [
          //       JUIText(
          //         title,
          //         fontSize: isSelected ? 17 : 13,
          //         color: isSelected ? Colors.red : Colors.blue,
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       JUIButton(
          //         icon: Icons.abc,
          //       )
          //     ],
          //   ));
          // },
          topWidgetBuilder: (context) {
            return Container(
              height: 100,
              color: Colors.amber,
            );
          },
          widgets: List.generate(3, (index) {
            return AlivePage1(
                // key: PageStorageKey<int>(index),
                );

            return CustomScrollView(
              key: PageStorageKey<int>(index),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: 44),
                ),
                SliverList(delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.blue,
                        child: JUIText(
                          '$index',
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ))
              ],
            );
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10), //设置padding，避免默认的Padding
              itemExtent: 200,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.blue,
                    child: JUIText(
                      '123',
                      color: Colors.white,
                    ),
                  ),
                );
              },
              itemCount: 20,
            );
          }),
          // bodyWidgetBuilder: (context, index) {
          //   return ListView.builder(
          //     padding: const EdgeInsets.only(top: 10), //设置padding，避免默认的Padding
          //     itemExtent: 200,
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 5),
          //         child: Container(
          //           margin: const EdgeInsets.symmetric(horizontal: 10),
          //           color: Colors.blue,
          //           child: JUIText(
          //             '123',
          //             color: Colors.white,
          //           ),
          //         ),
          //       );
          //     },
          //     itemCount: 20,
          //   );
          // },
          // underLineBorderSide: BorderSide(
          //   width: 3.5,
          //   color: Colors.green,
          // ),
        ));
  }
}
