import 'package:flutter/material.dart';

import '../common/jui_refresh.dart';

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
    double? width,
  }) {
    var viewModel = this;
    return viewModel.dataList.isEmpty
        ? SizedBox(
            width: width,
            child: emptyWidget,
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
    double topMargin = 30,
    Widget? emptyWidget,
  }) {
    if (dataList.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
            margin: EdgeInsets.only(top: topMargin), child: emptyWidget),
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
      Widget? emptyWidget,
      bool separatorDivider = true,
      ScrollController? scrollController}) {
    var viewModel = this;
    return viewModel.dataList.isEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              return emptyWidget;
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
