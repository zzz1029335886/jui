import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart' as er;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef JUIRefreshIndicatorResult = er.IndicatorResult;
typedef JUIEasyRefreshController = er.EasyRefreshController;
typedef EasyRefresh = er.EasyRefresh;

class JUIRefresh extends StatefulWidget {
  final Widget child;
  final JUIEasyRefreshController? controller;
  final ScrollController? scrollController;
  final bool refreshOnStart;
  final ValueChanged<JUIEasyRefreshController>? createdController;
  final VoidCallback? refreshAnimationComplete;
  final VoidCallback? loadAnimationComplete;

  final FutureOr Function()? onLoad;
  final FutureOr Function()? onRefresh;

  const JUIRefresh(
      {required this.child,
      this.onLoad,
      this.onRefresh,
      this.scrollController,
      this.refreshOnStart = false,
      this.createdController,
      this.refreshAnimationComplete,
      this.loadAnimationComplete,
      this.controller,
      super.key});

  @override
  State<JUIRefresh> createState() => _JUIRefreshState();
}

class _JUIRefreshState extends State<JUIRefresh> {
  late JUIEasyRefreshController refreshController;
  late final JUIEasyRefreshController _refreshController =
      JUIEasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();

    refreshController = widget.controller ?? _refreshController;
    widget.createdController?.call(refreshController);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      refreshController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return er.EasyRefresh(
      header: header(),
      footer: footer(),
      // header: const er.CupertinoHeader(
      //     position: er.IndicatorPosition.locator,
      //     safeArea: false,
      //     foregroundColor: Colors.blue,
      //     backgroundColor: Colors.red),
      // footer: const er.CupertinoFooter(
      //   position: er.IndicatorPosition.locator,
      // ),
      // scrollController: widget.scrollController,
      onRefresh: widget.onRefresh == null
          ? null
          : () {
              var res = widget.onRefresh?.call();
              if (res is Future) {
                if (res is Future<JUIRefreshIndicatorResult>) {
                  res.then((value) {
                    refreshController.finishRefresh(value);
                    widget.refreshAnimationComplete?.call();
                  });
                } else {
                  res.whenComplete(() {
                    refreshController
                        .finishRefresh(JUIRefreshIndicatorResult.success);
                    widget.refreshAnimationComplete?.call();
                  });
                }
              } else if (res is JUIRefreshIndicatorResult) {
                refreshController.finishRefresh(res);
                widget.refreshAnimationComplete?.call();
              } else {
                refreshController
                    .finishRefresh(JUIRefreshIndicatorResult.success);
                widget.refreshAnimationComplete?.call();
              }
            },
      onLoad: widget.onLoad == null
          ? null
          : () {
              var res = widget.onLoad?.call();
              if (res is Future) {
                if (res is Future<JUIRefreshIndicatorResult>) {
                  res.then((value) {
                    refreshController.finishLoad(value);
                    widget.loadAnimationComplete?.call();
                  });
                } else {
                  res.whenComplete(() {
                    refreshController
                        .finishLoad(JUIRefreshIndicatorResult.success);
                    widget.loadAnimationComplete?.call();
                  });
                }
              } else if (res is JUIRefreshIndicatorResult) {
                refreshController.finishLoad(res);
                widget.loadAnimationComplete?.call();
              } else {
                refreshController.finishLoad(JUIRefreshIndicatorResult.success);
                widget.loadAnimationComplete?.call();
              }
            },
      refreshOnStart: widget.refreshOnStart,
      controller: refreshController,
      child: widget.child,
    );
  }

  er.Footer? footer() {
    return const er.ClassicFooter(
      dragText: '上拉加载',
      armedText: '释放刷新',
      readyText: '加载中...',
      processingText: '加载中...',
      processedText: '加载完成',
      noMoreText: '没有更多内容',
      failedText: '加载失败',
      messageText: '最后更新于 %T',
      // noMoreIcon: Container(),
      // succeededIcon: Container(),
      // failedIcon: Container(),
      // iconDimension: 0,
      // spacing: 0,
      textStyle:
          TextStyle(fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
      showMessage: false, // 隐藏更新时间
    );
  }

  er.Header? header() {
    return const er.ClassicHeader(
      dragText: '下拉刷新',
      armedText: '释放刷新',
      readyText: '加载中...',
      processingText: '加载中...',
      processedText: '加载完成',
      noMoreText: '没有更多',
      failedText: '加载失败',
      messageText: '最后更新于 %T',
      textStyle:
          TextStyle(fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
    );
  }
}

class JUIPagingListWidget extends StatelessWidget {
  final JUIPageListRefreshModel pageModel;
  final VoidCallback? refreshCompleted;
  final ScrollController? scrollController;
  final Widget child;
  final bool refreshOnStart;
  final bool isSingleScrollView;

  JUIPagingListWidget({
    super.key,
    required this.pageModel,
    required this.child,
    this.refreshCompleted,
    this.scrollController,
    this.refreshOnStart = true,
    this.isSingleScrollView = true,
  }) : super() {
    pageModel._notifyRefresh = () {
      refreshCompleted?.call();
    };
  }

  @override
  Widget build(BuildContext context) {
    return JUIRefresh(
      scrollController: scrollController,
      onRefresh: () {
        var future = pageModel.onRefreshDown(callConRefresh: false);
        return complete(future);
      },
      onLoad: () {
        var future = pageModel.onLoadUp(callConRefresh: false);
        return complete(future);
      },
      refreshOnStart: refreshOnStart,
      createdController: (JUIEasyRefreshController controller) {
        pageModel._refreshController = controller;
        if (!isSingleScrollView) {
          pageModel.refreshWithOutAnimate();
        }
      },
      refreshAnimationComplete: () {
        refreshCompleted?.call();
        pageModel.refreshAnimationComplete();
      },
      loadAnimationComplete: () {
        refreshCompleted?.call();
        pageModel.loadAnimationComplete();
      },
      child: child,
    );
  }

  Future<JUIRefreshIndicatorResult> complete(Future<List> future) {
    Completer<JUIRefreshIndicatorResult> completer = Completer();
    future.then((value) {
      if (value.length < pageModel.pagingSize) {
        pageModel._refreshController
            .finishLoad(JUIRefreshIndicatorResult.noMore);
      } else {
        pageModel._refreshController.resetFooter();
      }
      completer.complete(JUIRefreshIndicatorResult.success);
    }).catchError((onError) {
      completer.complete(JUIRefreshIndicatorResult.fail);
    });

    return completer.future;
  }
}

abstract class JUIPageListRefreshModel<T> {
  late JUIEasyRefreshController _refreshController;

  JUIEasyRefreshController get refreshController => _refreshController;
  // ignore: constant_identifier_names
  static const int _DEFAULT_START_PAGE_INDEX = 1;
  // ignore: constant_identifier_names
  static const int _DEFAULT_PAGE_SIZE = 10;

  int _currPageIndex = _DEFAULT_START_PAGE_INDEX - 1;
  int _lastPageIndex = _DEFAULT_START_PAGE_INDEX;

  int get pagingSize => _DEFAULT_PAGE_SIZE;
  bool _isLoading = false;
  final List<T> _dataList = [];

  List<T> get dataList => _dataList;

  Future<List<T>> load(int pageIndex, int pageSize);

  void refreshAnimationComplete() {}
  void loadAnimationComplete() {}

  VoidCallback? _notifyRefresh;
  void refreshWithOutAnimate() {
    // EasyLoading.show();

    var future = _loadPage(isRefresh: true);
    future.then((value) {
      // EasyLoading.dismiss();
      _notifyRefresh?.call();

      if (value.length < pagingSize) {
        refreshController.finishLoad(JUIRefreshIndicatorResult.noMore);
      } else {
        if (refreshController.footerState?.result ==
            JUIRefreshIndicatorResult.noMore) {
          refreshController.resetFooter();
        } else {
          refreshController.finishRefresh(JUIRefreshIndicatorResult.success);
        }
      }
    }).catchError((onError) {
      EasyLoading.dismiss();
      refreshController.finishRefresh(JUIRefreshIndicatorResult.fail);
    });
  }

  Future<List<T>> onLoadUp(
      {bool callConRefresh = true, ScrollController? scrollController}) {
    if (callConRefresh) {
      refreshController.callLoad(scrollController: scrollController);
      return Future.sync(() => []);
    }
    return _loadPage(isRefresh: false);
  }

  Future<List<T>> onRefreshDown(
      {bool callConRefresh = true, ScrollController? scrollController}) {
    if (callConRefresh) {
      refreshController.callRefresh(scrollController: scrollController);
      return Future.sync(() => []);
    }
    return _loadPage(isRefresh: true);
  }

  void _onFinish(bool succeed) {
    if (succeed) {
      _lastPageIndex = _currPageIndex;
    } else {
      _currPageIndex = _lastPageIndex;
    }
  }

  int _handlePageIndex(int currPageIndex, int pageSize) {
    return ++currPageIndex;
  }

  int _handlePage(int currPageIndex, int pageSize) {
    return pageSize;
  }

  Future<List<T>>? loadingFuture;

  Future<List<T>> _loadPage({bool isRefresh = true}) async {
    if (_isLoading && loadingFuture != null) {
      await loadingFuture;
    }

    _isLoading = true;
    _currPageIndex = isRefresh
        ? _DEFAULT_START_PAGE_INDEX
        : _handlePageIndex(_currPageIndex, pagingSize);
    Future<List<T>> future =
        load(_currPageIndex, _handlePage(_currPageIndex, pagingSize));

    loadingFuture = future;

    future.then((data) {
      if (isRefresh) dataList.clear();
      dataList.addAll(data);

      _onFinish(true);
    }).catchError((e) {
      _onFinish(false);
    }).whenComplete(() {
      _isLoading = false;
      loadingFuture = null;
    });
    return future;
  }
}
