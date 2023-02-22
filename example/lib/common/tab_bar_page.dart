import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});
  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  late TabController tabController;
  final List<String> titles = ['1', '2', '3', '4'];

  get vsync => null;
  @override
  void initState() {
    tabController = TabController(length: titles.length, vsync: vsync);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SafeArea(
          child: Container(
        child: JUITabBar(
          titles: ['1', '2'],
          tabController: tabController,
        ),
      )),
    );
  }
}
