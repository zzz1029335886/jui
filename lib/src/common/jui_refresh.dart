import 'package:easy_refresh/easy_refresh.dart' as er;
import 'package:flutter/material.dart';
import 'package:jieluoxuan_bundle_base/jieluoxuan_bundle_base.dart';

class JUIPagingListWidgetState extends State<PagingListWidget> {
  er.EasyRefreshController refreshController = er.EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  int index = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();

    ValueChanged<er.EasyRefreshController>? valueChanged =
        widget.extra?['_createController'];
    valueChanged?.call(refreshController);

    refreshAnimationCompleteCallback =
        widget.extra?['_refreshAnimationCompleteCallback'];
    loadAnimationCompleteCallback =
        widget.extra?['_loadAnimationCompleteCallback'];
  }

  VoidCallback? refreshAnimationCompleteCallback;
  VoidCallback? loadAnimationCompleteCallback;
  bool hasFooter = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.controller
    // controller.callRefresh()
    // controller.callLoad()

    return er.EasyRefresh(
      controller: refreshController,
      refreshOnStart: true,
      onLoad: !hasFooter
          ? null
          : () async {
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
      onRefresh: () async {
        index = 1;
        var future = widget.onLoad.call(index, pageSize);
        future.then((value) {
          refreshController.finishRefresh(er.IndicatorResult.success);
          if (value.length < pageSize) {
            refreshController.finishLoad(er.IndicatorResult.noMore);
          }
          refreshAnimationCompleteCallback?.call();
          setState(() {
            hasFooter = value.isNotEmpty;
          });
        }).catchError((onError) {
          refreshController.finishRefresh(er.IndicatorResult.fail);
          refreshAnimationCompleteCallback?.call();
          setState(() {
            hasFooter = false;
          });
        });
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
      footer: er.ClassicFooter(
        dragText: '上拉加载',
        armedText: '释放刷新',
        readyText: '加载中...',
        processingText: '加载中...',
        processedText: '加载完成',
        noMoreText: '没有更多内容',
        failedText: '加载失败',
        messageText: '最后更新于 %T',
        noMoreIcon: Container(),
        textStyle: const TextStyle(
            fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
        showMessage: false, // 隐藏更新时间
      ),
      child: widget.child,
    );
  }
}

class JUIPagingListWidget extends StatelessWidget {
  final JUIPageListRefreshModel pageModel;
  final VoidCallback? animationComplete;
  final Widget child;
  final bool initialRefresh;
  final bool enablePullDown;
  final bool enablePullUp;

  const JUIPagingListWidget(
      {super.key,
      required this.pageModel,
      required this.child,
      this.animationComplete,
      this.initialRefresh = false,
      this.enablePullDown = true,
      this.enablePullUp = true});

  @override
  Widget build(BuildContext context) {
    return PagingListWidget(
      dataList: pageModel.dataList,
      onLoad: (pageIndex, pageSize) {
        if (pageIndex <= 1) {
          return pageModel.onRefreshDown(callConRefresh: false);
        } else {
          return pageModel.onLoadUp(callConRefresh: false);
        }
      },
      extra: {
        "_createController": (er.EasyRefreshController controller) {
          pageModel._refreshController = controller;
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

  Future<List<T>> onLoadUp({bool callConRefresh = true}) {
    if (callConRefresh) {
      refreshController.callLoad();
      return Future.sync(() => []);
    }
    return _loadPage(isRefresh: false);
  }

  Future<List<T>> onRefreshDown({bool callConRefresh = true}) {
    if (callConRefresh) {
      refreshController.callRefresh();
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

  Future<List<T>> _loadPage({bool isRefresh = true}) {
    assert(_isLoading == false);

    _isLoading = true;
    _currPageIndex = isRefresh
        ? _DEFAULT_START_PAGE_INDEX
        : _handlePageIndex(_currPageIndex, pagingSize);
    Future<List<T>> future =
        load(_currPageIndex, _handlePage(_currPageIndex, pagingSize));

    future.then((data) {
      if (isRefresh) dataList.clear();
      dataList.addAll(data);

      _onFinish(true);
    }).catchError((e) {
      _onFinish(false);
    }).whenComplete(() {
      _isLoading = false;
    });
    return future;
  }
}
