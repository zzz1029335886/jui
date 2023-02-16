import 'package:easy_refresh/easy_refresh.dart' as er;
import 'package:flutter/material.dart';
import 'package:jieluoxuan_bundle_base/jieluoxuan_bundle_base.dart';

class JUIPagingListWidgetState extends State<PagingListWidget> {
  er.EasyRefreshController _controller = er.EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  int index = 1;
  int pageSize = 10;

  @override
  Widget build(BuildContext context) {
    return er.EasyRefresh(
      controller: _controller,
      refreshOnStart: true,
      onLoad: () async {
        index++;
        var res = await widget.onLoad.call(index, pageSize);
        _controller.finishLoad(res.length == pageSize
            ? er.IndicatorResult.success
            : er.IndicatorResult.noMore);
      },
      onRefresh: () async {
        index = 1;
        var res = await widget.onLoad.call(index, pageSize);
        _controller.finishRefresh(er.IndicatorResult.success);
      },
      header: const er.ClassicHeader(
        dragText: '下拉刷新',
        armedText: '释放刷新',
        readyText: '加载中...',
        processingText: '加载中...',
        processedText: '加载完成',
        noMoreText: '没有更多',
        failedText: '加载失败',
        messageText: '最后更新于 %T',
      ),
      footer: const er.ClassicFooter(
        dragText: '上拉加载',
        armedText: '释放刷新',
        readyText: '加载中...',
        processingText: '加载中...',
        processedText: '加载完成',
        noMoreText: '没有更多',
        failedText: '加载失败',
        messageText: '最后更新于 %T',
        showMessage: false, // 隐藏更新时间
      ),
      child: widget.child,
    );
  }
}

// class JUIRefresh extends StatefulWidget {
//   const JUIRefresh({super.key});

//   @override
//   State<JUIRefresh> createState() => _JUIRefreshState();
// }

// class _JUIRefreshState extends State<JUIRefresh> {
//   @override
//   Widget build(BuildContext context) {
//     return PagingListWidget(
//       child: Container(),
//       dataList: [],
//       onLoad: (pageIndex, pageSize) {
//         return Future(() {
//           return [];
//         });
//       },
//     );
//   }
// }
