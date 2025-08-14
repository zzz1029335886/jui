import 'package:flutter/widgets.dart';

class JUIPageListConfig {
  final Widget Function()? defaultEmptyWidgetBuilder;
  final bool separatorDivider;
  final double defaultTopMargin;
  final double? emptyWidgetWidth;

  const JUIPageListConfig({
    this.defaultEmptyWidgetBuilder,
    this.separatorDivider = true,
    this.defaultTopMargin = 30,
    this.emptyWidgetWidth,
  });
}

class JUIRefreshTextConfig {
  final String dragText; //: '上拉加载',
  final String armedText; // '释放刷新',
  final String readyText; // '加载中...',
  final String processingText; // '加载中...',
  final String processedText; // '加载完成',
  final String noMoreText; // '没有更多内容',
  final String failedText; // '加载失败',
  final String messageText; //: '最后更新于 %T',
  final bool showMessage; //: 显示刷新时间,

  const JUIRefreshTextConfig({
    required this.dragText,
    this.armedText = '释放刷新',
    this.readyText = '加载中...',
    this.processingText = '加载中...',
    this.processedText = '加载完成',
    this.noMoreText = '没有更多内容',
    this.failedText = '加载失败',
    this.messageText = '最后更新于 %T',
    this.showMessage = true,
  });
}

class JUISettings {
  static JUIPageListConfig _pageListConfig = const JUIPageListConfig();
  static JUIRefreshTextConfig _refreshHeaderTextConfig =
      const JUIRefreshTextConfig(dragText: '下拉刷新');
  static JUIRefreshTextConfig _refreshFooterTextConfig =
      const JUIRefreshTextConfig(dragText: '上拉加载');
  static void init({
    JUIPageListConfig? pageListConfig,
    JUIRefreshTextConfig? refreshHeaderTextConfig,
    JUIRefreshTextConfig? refreshFooterTextConfig,
  }) {
    if (pageListConfig != null) {
      _pageListConfig = pageListConfig;
    }
    if (refreshHeaderTextConfig != null) {
      _refreshHeaderTextConfig = refreshHeaderTextConfig;
    }
    if (refreshFooterTextConfig != null) {
      _refreshFooterTextConfig = refreshFooterTextConfig;
    }
  }

  static JUIPageListConfig get pageListConfig => _pageListConfig;
  static JUIRefreshTextConfig get refreshHeaderTextConfig =>
      _refreshHeaderTextConfig;
  static JUIRefreshTextConfig get refreshFooterTextConfig =>
      _refreshFooterTextConfig;
}
