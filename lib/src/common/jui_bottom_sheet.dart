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
  static Future show({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isCupertino = true,
    bool expand = true,
    bool enableDrag = true,
  }) {
    if (isCupertino) {
      return showCupertinoModalBottomSheet(
          backgroundColor: Colors.red.withOpacity(0.6),
          transitionBackgroundColor: Colors.blue.withOpacity(0.6),
          context: context,
          builder: builder,
          expand: expand,
          enableDrag: enableDrag);
    } else {
      return showMaterialModalBottomSheet(
          backgroundColor: Colors.red.withOpacity(0.6),
          // transitionBackgroundColor: Colors.blue.withOpacity(0.6),
          context: context,
          builder: builder,
          expand: expand,
          enableDrag: enableDrag);
    }
  }

  static ScrollController? scrollController(BuildContext context) {
    return ModalScrollController.of(context);
  }

  static Future showPage(
      {required BuildContext context,
      required WidgetBuilder contentBuilder,
      bool isCupertino = true,
      bool expand = true,
      bool enableDrag = true,
      String? title,
      Widget? trailingWidget,
      Widget? leadingWidget}) {
    return show(
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

  static Future select(
      {required BuildContext context,
      required List<String> titles,
      JUIBottomClickTitleCallback? callback,
      bool showCancel = true}) {
    return showMaterialModalBottomSheet(
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

  static Future showPageContent(
      {required BuildContext context,
      required WidgetBuilder contentBuilder,
      bool isCupertino = true,
      bool expand = true,
      bool enableDrag = true,
      String? title,
      Widget? trailingWidget,
      Widget? leadingWidget}) {
    return showPage(
        context: context,
        contentBuilder: contentBuilder,
        isCupertino: isCupertino,
        expand: expand,
        enableDrag: enableDrag,
        trailingWidget: trailingWidget,
        leadingWidget: leadingWidget,
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
        child: widget.contentBuilder(context),
      ),
    ));
  }
}

typedef JUIBottomClickTitleCallback = Future<bool>? Function(
  BuildContext context,
  String title,
  int index,
);

class _SelectedTitleContent extends StatelessWidget {
  final List<String> titles;
  final JUIBottomClickTitleCallback? callback;

  const _SelectedTitleContent({required this.titles, this.callback});

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
                  var res = callback?.call(context, titles[index], index);
                  if (res != null) {
                    res.then((value) {
                      if (value) {
                        Navigator.of(context).pop();
                      }
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                }),
          )).toList(),
    );
  }
}
