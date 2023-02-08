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
        body: JUITabBarScrollView(
          titles: ['1', '2', '3', '4'],
          isScrollable: true,
          titleWidgetBuilder: (context, title, index) {
            return Text(title);
          },
          headerBuilder: (context) {
            return Container(
              height: 100,
              color: Colors.amber,
            );
          },
          bodyWidgetBuilder: (context, index) {
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
          },
          underLineBorderSide: BorderSide(
            width: 3.5,
            color: Colors.green,
          ),
        ));
  }
}
