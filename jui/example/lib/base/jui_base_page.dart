import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class JUIBasePage extends StatefulWidget {
  const JUIBasePage({super.key});

  @override
  State<JUIBasePage> createState() => _JUIBasePageState();
}

class _JUIBasePageState extends State<JUIBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [JUIText('title')],
      )),
    );
  }
}
