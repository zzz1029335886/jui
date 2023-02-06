import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class JUIShrinkWidgetPage extends StatefulWidget {
  const JUIShrinkWidgetPage({super.key});

  @override
  State<JUIShrinkWidgetPage> createState() => _JUIShrinkWidgetPageState();
}

class _JUIShrinkWidgetPageState extends State<JUIShrinkWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: JUIShrinkWidget(
              parent: Container(
                alignment: Alignment.centerLeft,
                child: Expanded(child: JUIText('parent')),
                height: 44,
              ),
              closeTitle: JUIText('展开'),
              openTitle: JUIText('关闭'),
              arrowColor: Colors.amber,
              child: Container(
                color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: JUIText('child'),
                      height: 100,
                    ),
                  ],
                ),
              ))),
    );
  }
}
