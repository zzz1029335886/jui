import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/jui.dart';
import 'package:jui_modal_bottom_sheet/modal_bottom_sheet.dart';

class JUIBottomSheetModalsPageRoute extends MaterialWithModalsPageRoute {
  JUIBottomSheetModalsPageRoute(
      {required super.builder,
      super.settings,
      super.maintainState,
      super.fullscreenDialog});
}

class JUIBottomSheet {
  static show({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isCupertino = true,
    bool expand = true,
    bool enableDrag = true,
  }) {
    if (isCupertino) {
      showCupertinoModalBottomSheet(
          context: context,
          builder: builder,
          expand: expand,
          enableDrag: enableDrag);
    } else {
      showMaterialModalBottomSheet(
          context: context,
          builder: builder,
          expand: expand,
          enableDrag: enableDrag);
    }
  }

  static ScrollController? scrollController(BuildContext context) {
    return ModalScrollController.of(context);
  }

  static showPage(
      {required BuildContext context,
      required WidgetBuilder contentBuilder,
      bool isCupertino = true,
      bool expand = true,
      bool enableDrag = true,
      String? title,
      Widget? trailingWidget,
      Widget? leadingWidget}) {
    show(
      context: context,
      expand: expand,
      enableDrag: enableDrag,
      builder: (context) {
        return JUIBottomSheetPage(
          contentBuilder: contentBuilder,
          title: title,
          leadingWidget: leadingWidget,
          trailingWidget: trailingWidget,
        );
      },
      isCupertino: isCupertino,
    );
  }

  static select(
      {required BuildContext context,
      required List<String> titles,
      JUIBottomClickTitleCallback? callback,
      bool isPop = true,
      bool showCancel = true}) {
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SelectedTitleContent(
                      titles: titles,
                      isPop: isPop,
                      callback: callback,
                    ),
                    if (showCancel)
                      Container(
                        height: 8,
                        color: const Color.fromRGBO(246, 248, 249, 1),
                      ),
                    if (showCancel)
                      ListTile(
                        title: const Center(
                          child: JUIText(
                            '取消',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pop(),
                      )
                  ],
                ),
              ),
            ));
  }

  static showPageContent(
      {required BuildContext context,
      required WidgetBuilder contentBuilder,
      bool isCupertino = true,
      bool expand = true,
      bool enableDrag = true,
      String? title}) {
    showPage(
        context: context,
        contentBuilder: contentBuilder,
        isCupertino: isCupertino,
        expand: expand,
        enableDrag: enableDrag,
        title: title);
  }
}

class JUIBottomSheetPage extends StatefulWidget {
  final WidgetBuilder contentBuilder;
  final Widget? trailingWidget;
  final Widget? leadingWidget;
  final String? title;

  const JUIBottomSheetPage(
      {super.key,
      required this.contentBuilder,
      this.title,
      this.leadingWidget,
      this.trailingWidget});

  @override
  State<JUIBottomSheetPage> createState() => _JUIBottomSheetPageState();
}

class _JUIBottomSheetPageState extends State<JUIBottomSheetPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      navigationBar: widget.title != null
          ? CupertinoNavigationBar(
              leading: widget.leadingWidget ??
                  Container(
                    width: 0,
                  ),
              middle: JUIText(
                widget.title!,
                color: const Color.fromRGBO(28, 31, 33, 1),
                fontWeight: FontWeight.w500,
              ),
              trailing: widget.trailingWidget ??
                  JUIButton(
                    icon: Icons.close,
                    color: const Color.fromRGBO(28, 31, 33, 1),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
              border: null,
            )
          : null,
      child: SafeArea(
        bottom: false,
        child: widget.contentBuilder(context),
      ),
    ));
  }
}

typedef void JUIBottomClickTitleCallback(String title, int index);

class _SelectedTitleContent extends StatelessWidget {
  final List<String> titles;
  final JUIBottomClickTitleCallback? callback;
  final bool isPop;

  const _SelectedTitleContent(
      {required this.titles, this.callback, this.isPop = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: ListTile.divideTiles(
          context: context,
          tiles: List.generate(
            titles.length,
            (index) => ListTile(
                minLeadingWidth: 16,
                title: Center(
                  child: JUIText(
                    titles[index],
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  callback?.call(titles[index], index);
                  if (isPop) {
                    Navigator.of(context).pop();
                  }
                }),
          )).toList(),
    );
  }
}
