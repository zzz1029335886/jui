import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});
  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> with TickerProviderStateMixin {
  late TabController tabController;
  final List<String> titles = ['待付款', '待付款', '待付款', '待付款', '待付款'];

  get vsync => null;
  @override
  void initState() {
    tabController = TabController(length: titles.length, vsync: this);
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
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: JUITabBar(
          titles: titles,
          underLineInsets: EdgeInsets.symmetric(horizontal: 16),
          tabController: tabController,
        ),
      )),
    );
  }
}
