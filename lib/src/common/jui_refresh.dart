import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart' as er;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    // return CupertinoSliverRefreshControl(
    //   builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance,
    //       refreshIndicatorExtent) {
    //     return widget.child;
    //   },
    // );

    // return RefreshIndicator(
    //   child: widget.child,
    //   onRefresh: () async {
    //     final res =
    //         await widget.onRefresh?.call() ?? JUIRefreshIndicatorResult.success;
    //     refreshController.finishRefresh(res);
    //     widget.refreshAnimationComplete?.call();
    //   },
    // );

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

      // header: const MaterialHeader(
      //   safeArea: false,
      // ),
      // footer: const MaterialFooter(
      //   position: IndicatorPosition.locator,
      // ),
      // footer: const ClassicFooter(
      //   triggerOffset: 100,
      //   position: IndicatorPosition.locator,
      //   dragText: '下拉刷新',
      //   armedText: '释放刷新',
      //   readyText: '加载中...',
      //   processingText: '加载中...',
      //   processedText: '加载完成',
      //   noMoreText: '没有更多',
      //   failedText: '加载失败',
      //   messageText: '最后更新于 %T',
      // ),
      resetAfterRefresh: false,
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
              // if (refreshController.footerState?.result ==
              //     JUIRefreshIndicatorResult.noMore) {
              //   refreshController.finishLoad(IndicatorResult.noMore, true);
              // }

              final res = await widget.onRefresh?.call() ??
                  JUIRefreshIndicatorResult.success;
              refreshController.finishRefresh(res);
              widget.refreshAnimationComplete?.call();

              // var res = widget.onRefresh?.call();
              // if (res is Future) {
              //   if (res is Future<JUIRefreshIndicatorResult>) {
              //     res.then((value) {
              //       refreshController.finishRefresh(value);
              //       widget.refreshAnimationComplete?.call();
              //     });
              //   } else {
              //     res.whenComplete(() {
              //       refreshController
              //           .finishRefresh(JUIRefreshIndicatorResult.success);
              //       widget.refreshAnimationComplete?.call();
              //     });
              //   }
              // } else if (res is JUIRefreshIndicatorResult) {
              //   refreshController.finishRefresh(res);
              //   widget.refreshAnimationComplete?.call();
              // } else {
              //   refreshController
              //       .finishRefresh(JUIRefreshIndicatorResult.success);
              //   widget.refreshAnimationComplete?.call();
              // }
            },
      onLoad: widget.onLoad == null
          ? null
          : () async {
              final res = await widget.onLoad?.call() ??
                  JUIRefreshIndicatorResult.success;
              refreshController.finishLoad(res);
              widget.loadAnimationComplete?.call();
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
  final VoidCallback? beforeRefresh;
  final ScrollController? scrollController;
  final Widget child;
  final bool refreshOnStart;
  final bool isSingleScrollView;

  JUIPagingListWidget({
    super.key,
    required this.pageModel,
    required this.child,
    int? pageSize,
    this.refreshCompleted,
    this.beforeRefresh,
    this.scrollController,
    this.refreshOnStart = true,
    this.isSingleScrollView = true,
  }) : super() {
    pageModel._customPagingSize = pageSize;

    pageModel.notifyRefresh = () {
      refreshCompleted?.call();
    };
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: JUIRefresh(
        scrollController: scrollController,
        onRefresh: () {
          beforeRefresh?.call();
          var future = pageModel.onRefreshDown(callConRefresh: false);
          return _complete(future, true);
        },
        onLoad: () {
          var future = pageModel.onLoadUp(callConRefresh: false);
          return _complete(future, false);
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
      ),
    );
  }

  Future<JUIRefreshIndicatorResult> _complete(
      Future<JUIPageListResultModel?> future, bool isRefresh) {
    Completer<JUIRefreshIndicatorResult> completer = Completer();
    future.then((value) {
      if (value != null) {
        if (isRefresh) {
          if (value.noMore) {
            pageModel._refreshController
                .finishLoad(JUIRefreshIndicatorResult.noMore);
          } else {
            pageModel._refreshController.resetFooter();
          }
          completer.complete(JUIRefreshIndicatorResult.success);
        } else {
          if (value.noMore) {
            completer.complete(JUIRefreshIndicatorResult.noMore);
          } else {
            completer.complete(JUIRefreshIndicatorResult.success);
          }
        }
      } else {
        completer.complete(JUIRefreshIndicatorResult.none);
      }
    }).catchError((onError) {
      completer.complete(JUIRefreshIndicatorResult.fail);
    });

    return completer.future;
  }
}

class JUIPageListResultModel<T> {
  List<T> list;
  bool noMore;
  JUIPageListResultModel(this.list, this.noMore);
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

  int get pagingSize => _customPagingSize ?? _DEFAULT_PAGE_SIZE;
  bool _isLoading = false;

  final _dataList = RxList<T>();

  List<T> get dataList => _dataList;

  set dataList(List<T> value) => _dataList.value = value;

  // final List<T> _dataList = [];
  // List<T> get dataList => _dataList;

  Future load(int pageIndex, int pageSize);

  int? _customPagingSize;

  void refreshAnimationComplete() {}

  void loadAnimationComplete() {}

  VoidCallback? notifyRefresh;

  void refreshWithOutAnimate() async {
    try {
      if (dataList.isNotEmpty) {
        return;
      }
      final value = await _loadPage(isRefresh: true);
      if (value.noMore) {
        refreshController.finishLoad(JUIRefreshIndicatorResult.noMore);
      } else {
        // refreshController.footerState?.result == JUIRefreshIndicatorResult.noMore
        refreshController.resetFooter();
      }
      refreshController.finishRefresh(JUIRefreshIndicatorResult.success);
    } catch (onError) {
      refreshController.finishRefresh(JUIRefreshIndicatorResult.fail);
    }

    notifyRefresh?.call();
  }

  Future<JUIPageListResultModel<T>?> onLoadUp(
      {bool callConRefresh = true, ScrollController? scrollController}) async {
    if (callConRefresh) {
      return refreshController
          .callLoad(scrollController: scrollController)
          .then((value) => null);
    }
    return _loadPage(isRefresh: false);
  }

  Future<JUIPageListResultModel<T>?> onRefreshDown(
      {bool callConRefresh = true, ScrollController? scrollController}) {
    if (callConRefresh) {
      return refreshController
          .callRefresh(scrollController: scrollController)
          .then((value) => null);
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

  Future<JUIPageListResultModel<T>>? loadingFuture;

  Future<JUIPageListResultModel<T>> _loadPage({bool isRefresh = true}) async {
    if (_isLoading && loadingFuture != null) {
      await loadingFuture;
    }

    _isLoading = true;
    _currPageIndex = isRefresh
        ? _DEFAULT_START_PAGE_INDEX
        : _handlePageIndex(_currPageIndex, pagingSize);
    Future future =
        load(_currPageIndex, _handlePage(_currPageIndex, pagingSize));

    if (future is Future<JUIPageListResultModel<T>>) {
      loadingFuture = future;
    } else if (future is Future<List<T>>) {
      loadingFuture = future.then(
          (value) => JUIPageListResultModel(value, value.length == pagingSize));
    } else {
      throw AssertionError("返回值错误，只能是 List<T> 或 JUIPageListResultModel<T>");
    }

    future.then((data) {
      if (isRefresh) dataList.clear();
      dataList.addAll(data.list);

      _onFinish(true);
    }).catchError((e) {
      _onFinish(false);
    }).whenComplete(() {
      _isLoading = false;
      loadingFuture = null;
    });
    return future as Future<JUIPageListResultModel<T>>;
  }
}
