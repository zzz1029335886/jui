import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart' as er;
import 'package:flutter/material.dart';
import 'package:jieluoxuan_bundle_base/jieluoxuan_bundle_base.dart';

typedef JUIRefreshIndicatorResult = er.IndicatorResult;

class JUIRefresh extends StatefulWidget {
  final Widget child;
  final er.EasyRefreshController? controller;
  final ScrollController? scrollController;
  final bool refreshOnStart;
  final FutureOr Function()? onLoad;
  final FutureOr Function()? onRefresh;

  const JUIRefresh(
      {required this.child,
      this.onLoad,
      this.onRefresh,
      this.scrollController,
      this.refreshOnStart = false,
      this.controller,
      super.key});

  @override
  State<JUIRefresh> createState() => _JUIRefreshState();
}

class _JUIRefreshState extends State<JUIRefresh> {
  late er.EasyRefreshController refreshController;
  late final er.EasyRefreshController _refreshController =
      er.EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();

    refreshController = widget.controller ?? _refreshController;
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
      scrollController: widget.scrollController,
      onRefresh: widget.onRefresh == null
          ? null
          : () {
              var res = widget.onRefresh?.call();
              if (res is Future) {
                if (res is Future<JUIRefreshIndicatorResult>) {
                  res.then((value) {
                    refreshController.finishRefresh(value);
                  });
                } else {
                  res.whenComplete(() {
                    refreshController.finishRefresh(er.IndicatorResult.success);
                  });
                }
              } else if (res is JUIRefreshIndicatorResult) {
                refreshController.finishRefresh(res);
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
                  });
                } else {
                  res.whenComplete(() {
                    refreshController.finishLoad(er.IndicatorResult.success);
                  });
                }
              } else if (res is JUIRefreshIndicatorResult) {
                refreshController.finishLoad(res);
              }
            },
      refreshOnStart: widget.refreshOnStart,
      controller: refreshController,
      child: widget.child,
    );
  }

  er.Footer? footer() {
    return er.ClassicFooter(
      dragText: '上拉加载',
      armedText: '释放刷新',
      readyText: '加载中...',
      processingText: '加载中...',
      processedText: '加载完成',
      noMoreText: '没有更多内容',
      failedText: '加载失败',
      messageText: '最后更新于 %T',
      noMoreIcon: Container(),
      succeededIcon: Container(),
      failedIcon: Container(),
      // iconDimension: 0,
      // spacing: 0,
      textStyle: const TextStyle(
          fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
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

class JUIPagingListWidgetState extends State<PagingListWidget> {
  late er.EasyRefreshController refreshController;

  int index = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();

    refreshController = er.EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    ValueChanged<er.EasyRefreshController>? valueChanged =
        widget.extra?['_createController'];
    valueChanged?.call(refreshController);

    refreshAnimationCompleteCallback =
        widget.extra?['_refreshAnimationCompleteCallback'];
    loadAnimationCompleteCallback =
        widget.extra?['_loadAnimationCompleteCallback'];
    refreshOnStart = widget.extra?['_refreshOnStart'];
  }

  VoidCallback? refreshAnimationCompleteCallback;
  VoidCallback? loadAnimationCompleteCallback;
  bool hasFooter = true;
  bool refreshOnStart = true;

  @override
  void dispose() {
    super.dispose();
    refreshController.dispose();
    refreshAnimationCompleteCallback = null;
    loadAnimationCompleteCallback = null;
  }

  @override
  Widget build(BuildContext context) {
    return JUIRefresh(
      controller: refreshController,
      scrollController: widget.controller,
      refreshOnStart: refreshOnStart,
      onLoad: !hasFooter
          ? null
          : () {
              index++;
              var future = widget.onLoad.call(index, pageSize);
              future.then((value) {
                refreshController.finishLoad(value.length == pageSize
                    ? er.IndicatorResult.success
                    : er.IndicatorResult.noMore);
                loadAnimationCompleteCallback?.call();
              }).catchError((onError) {
                refreshController.finishLoad(er.IndicatorResult.fail);
                loadAnimationCompleteCallback?.call();
              });
            },
      onRefresh: () {
        index = 1;
        var future = widget.onLoad.call(index, pageSize);
        future.then((value) {
          if (value.length < pageSize) {
            refreshController.finishLoad(er.IndicatorResult.noMore);
          } else {
            refreshController.finishRefresh(er.IndicatorResult.success);
          }
          refreshAnimationCompleteCallback?.call();
        }).catchError((onError) {
          refreshController.finishRefresh(er.IndicatorResult.fail);
          refreshAnimationCompleteCallback?.call();
        });
      },
      child: widget.child,
    );
  }
}

class JUIPagingListWidget extends StatelessWidget {
  final JUIPageListRefreshModel pageModel;
  final VoidCallback? animationComplete;
  final ScrollController? scrollController;
  final Widget child;
  final bool refreshOnStart;
  final bool isSingleScrollView;

  JUIPagingListWidget({
    super.key,
    required this.pageModel,
    required this.child,
    this.animationComplete,
    this.scrollController,
    this.refreshOnStart = true,
    this.isSingleScrollView = true,
  }) : super() {
    pageModel._notifyRefresh = () {
      animationComplete?.call();
    };
  }

  @override
  Widget build(BuildContext context) {
    return PagingListWidget(
      controller: scrollController,
      dataList: pageModel.dataList,
      onLoad: (pageIndex, pageSize) {
        if (pageIndex <= 1) {
          return pageModel.onRefreshDown(callConRefresh: false);
        } else {
          return pageModel.onLoadUp(callConRefresh: false);
        }
      },
      extra: {
        '_refreshOnStart': refreshOnStart,
        "_createController": (er.EasyRefreshController controller) {
          pageModel._refreshController = controller;
          if (!isSingleScrollView) {
            pageModel.refreshWithOutAnimate();
          }
        },
        '_refreshAnimationCompleteCallback': () {
          animationComplete?.call();
          pageModel.refreshAnimationComplete();
        },
        '_loadAnimationCompleteCallback': () {
          animationComplete?.call();
          pageModel.loadAnimationComplete();
        }

        // refreshAnimationCompleteCallback =
        //     widget.extra?['_refreshAnimationCompleteCallback'];
        // refreshAnimationCompleteCallback =
        //     widget.extra?['_loadAnimationCompleteCallback'];
      },
      child: child,
    );
  }
}

abstract class JUIPageListRefreshModel<T> {
  late er.EasyRefreshController _refreshController;

  er.EasyRefreshController get refreshController => _refreshController;
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
    var future = _loadPage(isRefresh: true);
    future.then((value) {
      _notifyRefresh?.call();

      if (value.length < pagingSize) {
        refreshController.finishLoad(er.IndicatorResult.noMore);
      } else {
        if (refreshController.footerState?.result ==
            er.IndicatorResult.noMore) {
          refreshController.resetFooter();
        } else {
          refreshController.finishRefresh(er.IndicatorResult.success);
        }
      }
    }).catchError((onError) {
      refreshController.finishRefresh(er.IndicatorResult.fail);
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
