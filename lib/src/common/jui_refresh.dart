import 'dart:async';

// import 'package:easy_refresh/easy_refresh.dart' as er;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jui/src/jui_setting.dart';
import 'package:pull_to_refresh_pro/pull_to_refresh_pro.dart';

// import '../other/classic_header.dart' as ch;

// typedef JUIRefreshIndicatorResult = RefreshStatus; //;er.IndicatorResult;
/// header state
enum JUIRefreshIndicatorResult {
  /// Initial state, when not being overscrolled into, or after the overscroll
  /// is canceled or after done and the sliver retracted away.
  idle,

  /// Dragged far enough that the onRefresh callback will callback
  canRefresh,

  /// the indicator is refreshing,waiting for the finish callback
  refreshing,

  /// the indicator refresh completed
  success,

  /// the indicator refresh failed
  fail,

  ///  Dragged far enough that the onTwoLevel callback will callback
  canTwoLevel,

  ///  indicator is opening twoLevel
  twoLevelOpening,

  /// indicator is in twoLevel
  twoLeveling,

  ///  indicator is closing twoLevel
  twoLevelClosing,

  noMore,

  none
}

// typedef JUIEasyRefreshController
//     = RefreshController; //er.EasyRefreshController;
typedef JUIRefresherBuilder = RefresherBuilder; //er.ERChildBuilder;

// typedef EasyRefresh = er.EasyRefresh;
class JUIRefreshController extends RefreshController {
  void finishRefresh(JUIRefreshIndicatorResult result) {
    switch (result) {
      case JUIRefreshIndicatorResult.success:
        refreshCompleted();
        break;
      case JUIRefreshIndicatorResult.fail:
        refreshFailed();
        break;
      case JUIRefreshIndicatorResult.none:
        refreshToIdle();
        break;
      case JUIRefreshIndicatorResult.idle:
      case JUIRefreshIndicatorResult.canRefresh:
      case JUIRefreshIndicatorResult.refreshing:
      case JUIRefreshIndicatorResult.canTwoLevel:
      case JUIRefreshIndicatorResult.twoLevelOpening:
      case JUIRefreshIndicatorResult.twoLeveling:
      case JUIRefreshIndicatorResult.twoLevelClosing:
      case JUIRefreshIndicatorResult.noMore:
        // Not applicable for this context
        break;
    }
  }

  void finishLoad([
    JUIRefreshIndicatorResult result = JUIRefreshIndicatorResult.success,
    bool focus = true,
  ]) {
    switch (result) {
      case JUIRefreshIndicatorResult.success:
        loadComplete();
        break;
      case JUIRefreshIndicatorResult.noMore:
        loadNoData();
        break;
      case JUIRefreshIndicatorResult.fail:
        loadFailed();
        break;
      case JUIRefreshIndicatorResult.none:
        resetFooter();
        break;
      case JUIRefreshIndicatorResult.idle:
      case JUIRefreshIndicatorResult.canRefresh:
      case JUIRefreshIndicatorResult.refreshing:
      case JUIRefreshIndicatorResult.canTwoLevel:
      case JUIRefreshIndicatorResult.twoLevelOpening:
      case JUIRefreshIndicatorResult.twoLeveling:
      case JUIRefreshIndicatorResult.twoLevelClosing:
        break;
    }
  }

  void resetFooter() {
    resetNoData();
  }

  Future callLoad({ScrollController? scrollController}) async {
    await requestLoading();
  }

  Future callRefresh({ScrollController? scrollController}) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      requestRefresh(duration: const Duration(milliseconds: 250));
    });
  }
}

class JUIRefresh extends StatefulWidget {
  final Widget? child;
  final JUIRefresherBuilder? childBuilder;
  final JUIRefreshController? controller;
  final ScrollController? scrollController;
  final bool refreshOnStart;
  final bool safeArea;
  final ValueChanged<JUIRefreshController>? createdController;
  final VoidCallback? refreshAnimationComplete;
  final VoidCallback? loadAnimationComplete;

  final FutureOr<JUIRefreshIndicatorResult> Function()? onLoad;
  final FutureOr<JUIRefreshIndicatorResult> Function()? onRefresh;

  const JUIRefresh(
      {this.child,
      this.childBuilder,
      this.onLoad,
      this.onRefresh,
      this.scrollController,
      this.refreshOnStart = false,
      this.safeArea = true,
      this.createdController,
      this.refreshAnimationComplete,
      this.loadAnimationComplete,
      this.controller,
      super.key})
      : assert((child == null) != (childBuilder == null));

  @override
  State<JUIRefresh> createState() => _JUIRefreshState();
}

class _JUIRefreshState extends State<JUIRefresh> {
  late JUIRefreshController refreshController;
  // late final JUIEasyRefreshController _refreshController =
  //     JUIEasyRefreshController(
  //   controlFinishRefresh: true,
  //   controlFinishLoad: false,
  // );
  final JUIRefreshController _refreshController = JUIRefreshController();

  @override
  void initState() {
    super.initState();

    refreshController = widget.controller ?? _refreshController;
    widget.createdController?.call(refreshController);
    if (widget.refreshOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        refreshController.requestRefresh();
      });
    }
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
    return RefreshConfiguration(
      springDescription: SpringDescription(
        mass: 1, // 质量
        stiffness: 80, // 刚度（越大越硬，回弹越快）
        damping: 15, // 阻尼（越大越快停下）
      ),
      child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: widget.onLoad != null,
          controller: refreshController,
          header: ClassicHeader(
            refreshStyle: RefreshStyle.follow,
            textStyle: JUISettings.refreshHeaderTextConfig.textStyle,
            completeDuration: const Duration(seconds: 1),
            releaseText: JUISettings.refreshHeaderTextConfig.armedText,
            refreshingText: JUISettings.refreshHeaderTextConfig.processingText,
            completeText: JUISettings.refreshHeaderTextConfig.processedText,
            idleText: JUISettings.refreshHeaderTextConfig.dragText,
            failedText: JUISettings.refreshHeaderTextConfig.failedText,
            failedIcon: const Icon(Icons.error, color: Colors.grey),
            completeIcon: const Icon(Icons.done, color: Colors.grey),
            idleIcon: const Icon(Icons.arrow_downward, color: Colors.grey),
            releaseIcon: const Icon(Icons.refresh, color: Colors.grey),
            refreshingIcon:
                const CupertinoActivityIndicator(color: Colors.grey),
          ),
          footer: ClassicFooter(
            loadStyle: LoadStyle.showWhenLoading,
            canLoadingText: JUISettings.refreshFooterTextConfig.armedText,
            idleText: JUISettings.refreshFooterTextConfig.dragText,
            loadingText: JUISettings.refreshFooterTextConfig.processingText,
            noDataText: JUISettings.refreshFooterTextConfig.noMoreText,
            failedText: JUISettings.refreshHeaderTextConfig.failedText,
            textStyle: JUISettings.refreshFooterTextConfig.textStyle,
            loadingIcon: SizedBox(
              width: 24,
              height: 24,
              child: CupertinoActivityIndicator(),
            ),
            completeDuration: const Duration(
              milliseconds: 1000,
            ),
          ),
          onRefresh: widget.onRefresh == null
              ? null
              : () async {
                  final res = await widget.onRefresh?.call() ??
                      JUIRefreshIndicatorResult.success;
                  refreshController.finishRefresh(res);
                  widget.refreshAnimationComplete?.call();
                },
          onLoading: widget.onLoad == null
              ? null
              : () async {
                  final res = await widget.onLoad?.call() ??
                      JUIRefreshIndicatorResult.success;
                  refreshController.finishLoad(res, true);
                  widget.loadAnimationComplete?.call();
                },
          child: widget.child),
    );
    // var header = ch.ClassicHeader(
    //     triggerOffset: 40,
    //     dragText: JUISettings.refreshHeaderTextConfig.dragText,
    //     armedText: JUISettings.refreshHeaderTextConfig.armedText,
    //     readyText: JUISettings.refreshHeaderTextConfig.readyText,
    //     processingText: JUISettings.refreshHeaderTextConfig.processingText,
    //     processedText: JUISettings.refreshHeaderTextConfig.processedText,
    //     noMoreText: JUISettings.refreshHeaderTextConfig.noMoreText,
    //     failedText: JUISettings.refreshHeaderTextConfig.failedText,
    //     messageText: JUISettings.refreshHeaderTextConfig.messageText,
    //     showMessage: JUISettings.refreshHeaderTextConfig.showMessage,
    //     iconTheme: JUISettings.refreshHeaderTextConfig.iconThemeData,
    //     textStyle: JUISettings.refreshHeaderTextConfig.textStyle,
    //     safeArea: widget.safeArea

    //     // position: er.IndicatorPosition.locator,
    //     );
    // var footer = er.ClassicFooter(
    //     dragText: JUISettings.refreshFooterTextConfig.dragText,
    //     armedText: JUISettings.refreshFooterTextConfig.armedText,
    //     readyText: JUISettings.refreshFooterTextConfig.readyText,
    //     processingText: JUISettings.refreshFooterTextConfig.processingText,
    //     processedText: JUISettings.refreshFooterTextConfig.processedText,
    //     noMoreText: JUISettings.refreshFooterTextConfig.noMoreText,
    //     failedText: JUISettings.refreshFooterTextConfig.failedText,
    //     messageText: JUISettings.refreshFooterTextConfig.messageText,
    //     showMessage: JUISettings.refreshFooterTextConfig.showMessage,
    //     noMoreIcon: null,
    //     iconTheme: JUISettings.refreshHeaderTextConfig.iconThemeData,
    //     textStyle: JUISettings.refreshFooterTextConfig.textStyle,
    //     safeArea: widget.safeArea
    //     // position: er.IndicatorPosition.locator,
    //     );
    // if (widget.child != null) {
    //   return er.EasyRefresh(
    //     spring: SpringDescription(
    //       mass: 1, // 质量
    //       stiffness: 100, // 刚度（越大越硬，回弹越快）
    //       damping: 15, // 阻尼（越大越快停下）
    //     ),
    //     scrollController: widget.scrollController,
    //     header: header,
    //     footer: footer,
    //     resetAfterRefresh: false,
    //     onRefresh: widget.onRefresh == null
    //         ? null
    //         : () async {
    //             final res = await widget.onRefresh?.call() ??
    //                 JUIRefreshIndicatorResult.success;
    //             refreshController.finishRefresh(res);
    //             widget.refreshAnimationComplete?.call();
    //           },
    //     onLoad: widget.onLoad == null
    //         ? null
    //         : () async {
    //             final res = await widget.onLoad?.call() ??
    //                 JUIRefreshIndicatorResult.success;
    //             refreshController.finishLoad(res, true);
    //             widget.loadAnimationComplete?.call();
    //             return res;
    //           },
    //     refreshOnStart: widget.refreshOnStart,
    //     controller: refreshController,
    //     child: widget.child,
    //   );
    // } else {
    //   return er.EasyRefresh.builder(
    //     spring: SpringDescription(
    //       mass: 1, // 质量
    //       stiffness: 100, // 刚度（越大越硬，回弹越快）
    //       damping: 15, // 阻尼（越大越快停下）
    //     ),
    //     scrollController: widget.scrollController,
    //     header: header,
    //     footer: footer,
    //     resetAfterRefresh: false,
    //     onRefresh: widget.onRefresh == null
    //         ? null
    //         : () async {
    //             final res = await widget.onRefresh?.call() ??
    //                 JUIRefreshIndicatorResult.success;
    //             refreshController.finishRefresh(res);
    //             widget.refreshAnimationComplete?.call();
    //           },
    //     onLoad: widget.onLoad == null
    //         ? null
    //         : () async {
    //             final res = await widget.onLoad?.call() ??
    //                 JUIRefreshIndicatorResult.success;
    //             refreshController.finishLoad(res, true);
    //             widget.loadAnimationComplete?.call();
    //             return res;
    //           },
    //     refreshOnStart: widget.refreshOnStart,
    //     controller: refreshController,
    //     childBuilder: widget.childBuilder,
    //   );
    // }
  }

  // er.Footer? footer() {
  //   return er.ClassicFooter(
  //     dragText: JUISettings.refreshFooterTextConfig.dragText,
  //     armedText: JUISettings.refreshFooterTextConfig.armedText,
  //     readyText: JUISettings.refreshFooterTextConfig.readyText,
  //     processingText: JUISettings.refreshFooterTextConfig.processingText,
  //     processedText: JUISettings.refreshFooterTextConfig.processedText,
  //     noMoreText: JUISettings.refreshFooterTextConfig.noMoreText,
  //     failedText: JUISettings.refreshFooterTextConfig.failedText,
  //     messageText: JUISettings.refreshFooterTextConfig.messageText,
  //     showMessage: JUISettings.refreshFooterTextConfig.showMessage,
  //     noMoreIcon: null,
  //     iconTheme: IconThemeData(
  //       color: Color.fromRGBO(147, 153, 159, 1),
  //     ),
  //     textStyle: const TextStyle(
  //         fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
  //   );
  // }

  // er.Header? header() {
  //   return er.ClassicHeader(
  //     triggerOffset: 18,
  //     readySpringBuilder: er.kBezierSpringBuilder,
  //     frictionFactor: er.kBezierFrictionFactor,
  //     dragText: JUISettings.refreshHeaderTextConfig.dragText,
  //     armedText: JUISettings.refreshHeaderTextConfig.armedText,
  //     readyText: JUISettings.refreshHeaderTextConfig.readyText,
  //     processingText: JUISettings.refreshHeaderTextConfig.processingText,
  //     processedText: JUISettings.refreshHeaderTextConfig.processedText,
  //     noMoreText: JUISettings.refreshHeaderTextConfig.noMoreText,
  //     failedText: JUISettings.refreshHeaderTextConfig.failedText,
  //     messageText: JUISettings.refreshHeaderTextConfig.messageText,
  //     showMessage: JUISettings.refreshHeaderTextConfig.showMessage,
  //     iconTheme: IconThemeData(
  //       color: Color.fromRGBO(147, 153, 159, 1),
  //     ),
  //     textStyle:
  //         TextStyle(fontSize: 12, color: Color.fromRGBO(147, 153, 159, 1)),
  //   );
  // }
}

class JUIPagingListWidget<T> extends StatelessWidget {
  final JUIPageListRefreshModel<T> pageModel;
  final VoidCallback? refreshCompleted;
  final VoidCallback? beforeRefresh;
  final ScrollController? scrollController;
  final JUIRefreshController? controller;

  final Widget child;
  final bool refreshOnStart;
  final bool isSingleScrollView;
  final bool isLodeMore;
  final bool safeArea;

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
    this.safeArea = true,
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
        safeArea: safeArea,
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
        createdController: (JUIRefreshController controller) {
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
  late JUIRefreshController _refreshController;

  JUIRefreshController get refreshController => _refreshController;

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

  Future<JUIPageListResultModel<T>?> onLoadUp(
      {bool callConRefresh = true, ScrollController? scrollController}) {
    return _onLoadUp(
        callConRefresh: callConRefresh, scrollController: scrollController);
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

  Future<JUIPageListResultModel<T>?> onRefreshDown(
      {bool callConRefresh = true, ScrollController? scrollController}) {
    return _onRefreshDown(
        callConRefresh: callConRefresh, scrollController: scrollController);
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
    try {
      var future =
          load(_currPageIndex, _handlePage(_currPageIndex, pagingSize));

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
    } catch (e) {
      _onFinish(false);
      rethrow;
    }
  }
}
