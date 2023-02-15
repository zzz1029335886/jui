///  base_refresh_view.dart
///
///  Created by iotjin on 2022/09/22.
///  description: EasyRefresh封装，支持骨架屏、设置header、footer、空数据与网络异常处理

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:easy_refresh/easy_refresh.dart';

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);

/// 父组件中调用 globalKeyRefresh.currentState.jhRequestData()
/// 初始化调用要延时加载
GlobalKey<BaseRefreshViewState> globalKeyRefresh = GlobalKey();

class BaseRefreshView extends StatefulWidget {
  const BaseRefreshView({
    Key? key,
    required this.data,
    this.limit = 15,
    this.enableShimmer = false,
    this.shimmerView,
    this.headerView,
    this.footerView,
    this.child,
    this.itemBuilder,
    this.separatorBuilder,
    this.onRefresh,
    this.onLoad,
    this.firstRefresh = false,
    this.header,
    this.footer,
    this.emptyText = '暂无数据',
    this.empty,
    this.controller,
  }) : super(key: key);

  final List data; // 数据
  final int limit; // 分页条数，为了控制上拉加载完成显示状态
  final bool enableShimmer; // 是否使用骨架屏，默认不使用，开启后初始化请求会显示骨架屏(需要设置shimmerView)
  final Widget? shimmerView; // 骨架屏view
  final Widget? headerView; // 头部view(跟随滚动)，设置后子组件要禁止滚动
  final Widget? footerView; // 尾部view(跟随滚动)，设置后子组件要禁止滚动
  final Widget? child; // 自定义子组件, 优先级高于itemBuilder，使用后itemBuilder失效
  final IndexedWidgetBuilder? itemBuilder; // listview子组件内的itemBuilder
  final IndexedWidgetBuilder? separatorBuilder; // listview子组件内的separatorBuilder
  final FutureOr Function()? onRefresh; // 刷新回调(null为不开启下拉刷新)
  final FutureOr Function()? onLoad; // 加载回调(null为不开启上拉加载)
  final bool firstRefresh; // 首次刷新
  final Header? header; // 不传使用默认header
  final Footer? footer; // 不传使用默认footer
  final String emptyText; // 空视图文字
  final Widget? empty; // 自定义空视图，优先级高于emptyText，设置后emptyText失效
  final EasyRefreshController? controller; // EasyRefresh controller

  @override
  State<BaseRefreshView> createState() => BaseRefreshViewState();
}

class BaseRefreshViewState<T extends BaseRefreshView> extends State<T> {
  bool _isShowShimmer = false;
  EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? _controller;
    _isShowShimmer = widget.enableShimmer;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    return EasyRefresh(
      controller: _controller,
      header: widget.header ?? _defaultHeader(),
      footer: widget.footer ?? _defaultFooter(),
      refreshOnStart: widget.firstRefresh,
      onRefresh: _isShowShimmer ? null : widget.onRefresh,
      onLoad: widget.data.isEmpty ? null : widget.onLoad,
      child: _listView(),
    );
  }

  Widget? _listView() {
    if (_isShowShimmer && widget.shimmerView != null) {
      return widget.shimmerView;
    }

    Widget child;
    if (widget.headerView == null && widget.footerView == null) {
      child = _defaultChild(false);
    } else {
      child = ListView(
        children: <Widget>[
          widget.headerView ?? Container(),
          _defaultChild(true),
          widget.footerView ?? Container(),
        ],
      );
    }

    return child;
  }

  Widget _defaultChild(bool hasHeaderOrFooter) {
    if (widget.data.isEmpty) {
      if (hasHeaderOrFooter) {
        return widget.empty ?? _emptyWidget();
      }
      return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => widget.empty ?? _emptyWidget(),
      );
    } else {
      // 如果使用自定义子组件，优先自定义组件
      if (widget.child != null) {
        return widget.child!;
      }
      return ListView.separated(
        shrinkWrap: hasHeaderOrFooter,
        physics:
            hasHeaderOrFooter ? const NeverScrollableScrollPhysics() : null,
        itemCount: widget.data.length,
        itemBuilder: widget.itemBuilder!,
        separatorBuilder: widget.separatorBuilder!,
      );
    }
  }

  Widget _emptyWidget() {
    return Container();
    // if (_isNetWorkError) {
    //   return JhEmptyView(
    //     type: EmptyType.error,
    //     clickCallBack: () async => _controller.callRefresh(),
    //   );
    // }
    // return JhEmptyView(text: widget.emptyText);
  }

  _defaultHeader() {
    return const ClassicHeader(
      dragText: '下拉刷新',
      armedText: '释放刷新',
      readyText: '加载中...',
      processingText: '加载中...',
      processedText: '加载完成',
      noMoreText: '没有更多',
      failedText: '加载失败',
      messageText: '最后更新于 %T',
    );
  }

  _defaultFooter() {
    return const ClassicFooter(
      dragText: '上拉加载',
      armedText: '释放刷新',
      readyText: '加载中...',
      processingText: '加载中...',
      processedText: '加载完成',
      noMoreText: '没有更多',
      failedText: '加载失败',
      messageText: '最后更新于 %T',
      showMessage: false, // 隐藏更新时间
    );
  }

  /// 设置EasyRefresh的默认样式
  // ignore: unused_element
  void _initEasyRefresh() {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
            dragText: 'Pull to refresh',
            armedText: 'Release ready',
            readyText: 'Refreshing...',
            processingText: 'Refreshing...',
            processedText: 'Succeeded',
            noMoreText: 'No more',
            failedText: 'Failed',
            messageText: 'Last updated at %T',
          );
      EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
            dragText: 'Pull to load',
            armedText: 'Release ready',
            readyText: 'Loading...',
            processingText: 'Loading...',
            processedText: 'Succeeded',
            noMoreText: 'No more',
            failedText: 'Failed',
            messageText: 'Last updated at %T',
          );
    });
  }
}
