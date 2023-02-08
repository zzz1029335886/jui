import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class SectionTitlePage extends StatefulWidget {
  const SectionTitlePage({super.key});

  @override
  State<SectionTitlePage> createState() => _SectionTitlePageState();
}

class _SectionTitlePageState extends State<SectionTitlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SectionTitle"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            JUISectionTitleContainer.defaultStyle(
              '默认配置',
              moreCallbackAction: (() {}),
              child: Container(
                alignment: Alignment.center,
                height: 100,
                color: Colors.amber,
                child: JUIText('背景白色，上下边距20，左右16，中间20'),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              color: Colors.blueAccent,
              child: JUISectionTitleContainer(
                '自定义',
                moreCallbackAction: () {},
                child: JUIText(''),
              ),
            )
          ],
        ),
      ),
    );
  }
}
