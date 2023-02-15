import 'package:flutter/material.dart';
import 'package:jieluoxuan_bundle_base/jieluoxuan_bundle_base.dart';

class JUIPagingListWidgetState extends State<PagingListWidget> {
  JUIPagingListWidgetState(RequestAction action);
  @override
  Widget build(BuildContext context) {
    return Text('123');
  }
}

class JUIRefresh extends StatefulWidget {
  const JUIRefresh({super.key});

  @override
  State<JUIRefresh> createState() => _JUIRefreshState();
}

class _JUIRefreshState extends State<JUIRefresh> {
  @override
  Widget build(BuildContext context) {
    return PagingListWidget(
      child: Container(),
      dataList: [],
      onLoad: (pageIndex, pageSize) {
        return Future(() {
          return [];
        });
      },
    );
  }
}
