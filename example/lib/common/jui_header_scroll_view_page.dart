import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class HeaderScrollViewPage extends StatefulWidget {
  const HeaderScrollViewPage({super.key});

  @override
  State<HeaderScrollViewPage> createState() => _HeaderScrollViewPageState();
}

class _HeaderScrollViewPageState extends State<HeaderScrollViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('固定顶部'),
      ),
      body: JUIHeaderScrollView(
          topWidgetBuilder: (context) {
            return Container(
              height: 100,
              color: Colors.greenAccent,
            );
          },
          headerWidgetBuilder: (context) {
            return PreferredSize(
                child: Container(
                  color: Colors.amber,
                  alignment: Alignment.center,
                  child: JUIText('title'),
                ),
                preferredSize: Size.fromHeight(44));
          },
          isScrollFullScreen: false,
          bodyWidgetBuilder: (context) {
            // return Column(
            //   children: List.generate(100, (index) {
            //     return Container(
            //       height: 44,
            //       margin: EdgeInsets.symmetric(vertical: 8),
            //       color: Colors.amber,
            //     );
            //   }),
            // );
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    height: 88,
                    color: Colors.amber,
                    margin: EdgeInsets.symmetric(vertical: 16),
                  );
                });
          }),
    );
  }
}
