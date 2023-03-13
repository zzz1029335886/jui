import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class EventAxisPage extends StatefulWidget {
  const EventAxisPage({super.key});
  @override
  State<EventAxisPage> createState() => _EventAxisStatePage();
}

class _EventAxisStatePage extends State<EventAxisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(children: [
            JUITitleLineWidget(
              isShowTopLine: false,
              title: '11月17日',
              itemHeight: 72,
              children: [
                Container(
                  color: Colors.grey[200],
                ),
                Container(
                  color: Colors.grey[200],
                ),
              ],
            ),
            JUITitleLineWidget(
              isShowTopLine: false,
              title: '11月17日',
              itemHeights: [72, 100],
              children: [
                Container(
                  color: Colors.grey[200],
                ),
                Container(
                  color: Colors.grey[200],
                ),
              ],
            ),
            JUITitleLineWidget(
              isShowTopLine: true,
              title: '11月18日',
              itemsHeight: 172,
              children: [
                Container(
                  color: Colors.grey[200],
                  height: 100,
                ),
                Container(
                  color: Colors.grey[200],
                  height: 72,
                ),
              ],
            ),
          ]),
        ),
      )),
    );
  }
}
