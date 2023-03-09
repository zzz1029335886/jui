import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});
  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SafeArea(
          child: Column(
        children: [
          JUITabBar(tabController: tabController, titles: ['1', '2', '3', '4'])
        ],
      )),
    );
  }
}
