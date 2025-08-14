import 'package:flutter/material.dart';

import '../common/jui_refresh.dart';
import '../jui_setting.dart';

export 'scroll_controller_extension.dart';

extension JUIFontWeightExtension on FontWeight {
  static const isIos = false;
  static const FontWeight medium = isIos ? FontWeight.w600 : FontWeight.w600;
}

typedef JUIPageListObjectListWidgetBuilder<T> = Widget? Function(
    BuildContext context, T object, int index);

typedef JUIPageListObjectColumnWidgetBuilder<T> = Widget? Function(
    T object, int index);

extension JUIPageListRefreshModelExtension<T> on JUIPageListRefreshModel<T> {
  Widget columnWithEmpty({
    required JUIPageListObjectColumnWidgetBuilder<T> itemBuilder,
    Widget? emptyWidget,
    double? topMargin = 0,
    double? width,
  }) {
    var viewModel = this;
    return viewModel.dataList.isEmpty
        ? Container(
            margin: EdgeInsets.only(
                top: topMargin ?? JUISettings.pageListConfig.defaultTopMargin),
            width: width ?? JUISettings.pageListConfig.emptyWidgetWidth,
            child: emptyWidget ??
                JUISettings.pageListConfig.defaultEmptyWidgetBuilder?.call(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(viewModel.dataList.length, (index) {
              var obj = viewModel.dataList[index];
              var widget = itemBuilder.call(obj, index);

              return widget!;
            }),
          );
  }

  Widget sliverListWithEmpty({
    required JUIPageListObjectListWidgetBuilder<T> itemBuilder,
    double? topMargin,
    Widget? emptyWidget,
    double? width,
  }) {
    if (dataList.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
            width: width ?? JUISettings.pageListConfig.emptyWidgetWidth,
            margin: EdgeInsets.only(
                top: topMargin ?? JUISettings.pageListConfig.defaultTopMargin),
            child: emptyWidget ??
                JUISettings.pageListConfig.defaultEmptyWidgetBuilder?.call()),
      );
    }

    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      var obj = dataList[index];
      var widget = itemBuilder.call(context, obj, index);
      return widget;
    }, childCount: dataList.length));
  }

  Widget listViewWithEmpty(
      {required JUIPageListObjectListWidgetBuilder<T> itemBuilder,
      double? topMargin,
      Widget? emptyWidget,
      double? width,
      bool separatorDivider = true,
      ScrollController? scrollController}) {
    var viewModel = this;

    return viewModel.dataList.isEmpty && !isRefreshing
        ? ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                width: width ?? JUISettings.pageListConfig.emptyWidgetWidth,
                margin: EdgeInsets.only(
                    top: topMargin ??
                        JUISettings.pageListConfig.defaultTopMargin),
                child: emptyWidget ??
                    JUISettings.pageListConfig.defaultEmptyWidgetBuilder
                        ?.call(),
              );
            },
            itemCount: 1,
          )
        : ListView.separated(
            controller: scrollController,
            itemBuilder: (context, index) {
              var obj = viewModel.dataList[index];
              var widget = itemBuilder.call(context, obj, index);

              return widget;
            },
            separatorBuilder: (context, index) {
              if (separatorDivider) {
                return const Divider(
                  height: 0.5,
                );
              } else {
                return Container();
              }
            },
            itemCount: viewModel.dataList.length);
  }
}
