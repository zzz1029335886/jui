import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart' as er;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jui/src/jui_setting.dart';

import '../other/classic_header.dart' as ch;

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

  final FutureOr<JUIRefreshIndicatorResult> Function()? onLoad;
  final FutureOr<JUIRefreshIndicatorResult> Function()? onRefresh;

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
    controlFinishLoad: false,
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
      header: ch.ClassicHeader(
        triggerOffset: 40,
        dragText: JUISettings.refreshHeaderTextConfig.dragText,
        armedText: JUISettings.refreshHeaderTextConfig.armedText,
        readyText: JUISettings.refreshHeaderTextConfig.readyText,
        processingText: JUISettings.refreshHeaderTextConfig.processingText,
        processedText: JUISettings.refreshHeaderTextConfig.processedText,
        noMoreText: JUISettings.refreshHeaderTextConfig.noMoreText,
        failedText: JUISettings.refreshHeaderTextConfig.failedText,
        messageText: JUISettings.refreshHeaderTextConfig.messageText,
        showMessage: JUISettings.refreshHeaderTextConfig.showMessage,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(147, 153, 159, 1),
        ),
        textStyle:
            TextStyle(fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
      ),
      footer: er.ClassicFooter(
        dragText: JUISettings.refreshFooterTextConfig.dragText,
        armedText: JUISettings.refreshFooterTextConfig.armedText,
        readyText: JUISettings.refreshFooterTextConfig.readyText,
        processingText: JUISettings.refreshFooterTextConfig.processingText,
        processedText: JUISettings.refreshFooterTextConfig.processedText,
        noMoreText: JUISettings.refreshFooterTextConfig.noMoreText,
        failedText: JUISettings.refreshFooterTextConfig.failedText,
        messageText: JUISettings.refreshFooterTextConfig.messageText,
        showMessage: JUISettings.refreshFooterTextConfig.showMessage,
        noMoreIcon: null,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(147, 153, 159, 1),
        ),
        textStyle: const TextStyle(
            fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
      ),
      resetAfterRefresh: false,
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
              final res = await widget.onRefresh?.call() ??
                  JUIRefreshIndicatorResult.success;
              refreshController.finishRefresh(res);
              widget.refreshAnimationComplete?.call();
            },
      onLoad: widget.onLoad == null
          ? null
          : () async {
              final res = await widget.onLoad?.call() ??
                  JUIRefreshIndicatorResult.success;
              refreshController.finishLoad(res, true);
              widget.loadAnimationComplete?.call();
              return res;
            },
      refreshOnStart: widget.refreshOnStart,
      controller: refreshController,
      child: widget.child,
    );
  }

  er.Footer? footer() {
    return er.ClassicFooter(
      dragText: JUISettings.refreshFooterTextConfig.dragText,
      armedText: JUISettings.refreshFooterTextConfig.armedText,
      readyText: JUISettings.refreshFooterTextConfig.readyText,
      processingText: JUISettings.refreshFooterTextConfig.processingText,
      processedText: JUISettings.refreshFooterTextConfig.processedText,
      noMoreText: JUISettings.refreshFooterTextConfig.noMoreText,
      failedText: JUISettings.refreshFooterTextConfig.failedText,
      messageText: JUISettings.refreshFooterTextConfig.messageText,
      showMessage: JUISettings.refreshFooterTextConfig.showMessage,
      noMoreIcon: null,
      iconTheme: IconThemeData(
        color: Color.fromRGBO(147, 153, 159, 1),
      ),
      textStyle: const TextStyle(
          fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
    );
  }

  er.Header? header() {
    return er.ClassicHeader(
      triggerOffset: 18,
      readySpringBuilder: er.kBezierSpringBuilder,
      frictionFactor: er.kBezierFrictionFactor,
      dragText: JUISettings.refreshHeaderTextConfig.dragText,
      armedText: JUISettings.refreshHeaderTextConfig.armedText,
      readyText: JUISettings.refreshHeaderTextConfig.readyText,
      processingText: JUISettings.refreshHeaderTextConfig.processingText,
      processedText: JUISettings.refreshHeaderTextConfig.processedText,
      noMoreText: JUISettings.refreshHeaderTextConfig.noMoreText,
      failedText: JUISettings.refreshHeaderTextConfig.failedText,
      messageText: JUISettings.refreshHeaderTextConfig.messageText,
      showMessage: JUISettings.refreshHeaderTextConfig.showMessage,
      iconTheme: IconThemeData(
        color: Color.fromRGBO(147, 153, 159, 1),
      ),
      textStyle:
          TextStyle(fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
    );
  }
}

class JUIPagingListWidget<T> extends StatelessWidget {
  final JUIPageListRefreshModel<T> pageModel;
  final VoidCallback? refreshCompleted;
  final VoidCallback? beforeRefresh;
  final ScrollController? scrollController;
  final JUIEasyRefreshController? controller;

  final Widget child;
  final bool refreshOnStart;
  final bool isSingleScrollView;
  final bool isLodeMore;

  JUIPagingListWidget({
    super.key,
    required this.pageModel,
    required this.child,
    int? pageSize,
    this.refreshCompleted,
    this.beforeRefresh,
    this.scrollController,
    this.controller,
    this.refreshOnStart = true,
    this.isSingleScrollView = true,
    this.isLodeMore = true,
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
        controller: controller,
        onRefresh: () {
          beforeRefresh?.call();
          var future = pageModel._onRefreshDown(callConRefresh: false);
          return _complete(future, true);
        },
        onLoad: pageModel.dataList.isEmpty
            ? null
            : () {
                var future = pageModel._onLoadUp(callConRefresh: false);
                return _complete(future, false);
              },
        refreshOnStart: refreshOnStart,
        createdController: (JUIEasyRefreshController controller) {
          pageModel._refreshController = controller;
          if (!isSingleScrollView) {
            pageModel._refreshWithOutAnimate();
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
                .finishLoad(JUIRefreshIndicatorResult.noMore, true);
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
      debugPrint('Error during refresh/load: $onError');
      completer.complete(JUIRefreshIndicatorResult.fail);
    });

    return completer.future;
  }
}

class JUIPageListResultModel<T> {
  List<T> list;
  bool noMore;
  JUIPageListResultModel({
    required this.list,
    required this.noMore,
  });
}

mixin JUIPageListRefreshModel<T> {
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
  bool isRefreshing = true;

  final _dataList = RxList<T>();

  List<T> get dataList => _dataList;

  set dataList(List<T> value) => _dataList.value = value;

  // final List<T> _dataList = [];
  // List<T> get dataList => _dataList;

  Future<JUIPageListResultModel<T>> load(int pageIndex, int pageSize);

  int? _customPagingSize;

  void refreshAnimationComplete() {}

  void loadAnimationComplete() {}

  VoidCallback? notifyRefresh;

  void _refreshWithOutAnimate() async {
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
      debugPrint('Refresh without animation error: $onError');
      refreshController.finishRefresh(JUIRefreshIndicatorResult.fail);
    }

    notifyRefresh?.call();
  }

  Future<JUIPageListResultModel<T>?> _onLoadUp(
      {bool callConRefresh = true, ScrollController? scrollController}) async {
    if (callConRefresh) {
      return refreshController
          .callLoad(scrollController: scrollController)
          .then((value) => null);
    }
    return _loadPage(isRefresh: false);
  }

  Future<JUIPageListResultModel<T>?> _onRefreshDown(
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
    if (isRefresh) dataList.clear();

    _isLoading = true;
    isRefreshing = isRefresh;
    _currPageIndex = isRefresh
        ? _DEFAULT_START_PAGE_INDEX
        : _handlePageIndex(_currPageIndex, pagingSize);
    var future = load(_currPageIndex, _handlePage(_currPageIndex, pagingSize));

    loadingFuture = future;

    future.then((data) {
      debugPrint('future then: $data');
      dataList.addAll(data.list);

      _onFinish(true);
    }).catchError((e) {
      _onFinish(false);
    }).whenComplete(() {
      _isLoading = false;
      isRefreshing = false;
      loadingFuture = null;
    });
    return future;
  }
}
