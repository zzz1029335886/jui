import 'package:flutter/material.dart';

import 'jui_page_control.dart';

class JUIPageContainer extends StatefulWidget {
  final List items;
  final int columnCount;
  final double padding;
  final double itemHeight;
  final double viewportFraction;

  final Widget Function(BuildContext context, int index, dynamic item)
      itemBuilder;

  final Function(int index, dynamic item)? clicked;

  const JUIPageContainer(
      {required this.items,
      required this.itemHeight,
      required this.viewportFraction,
      required this.itemBuilder,
      required this.columnCount,
      required this.padding,
      required this.clicked,
      super.key});

  static JUIPageContainer init<T>(
      {required List<T> items,
      required int columnCount,
      required double itemHeight,
      double viewportFraction = 1,
      double padding = 0,
      required Widget Function(BuildContext context, int index, T item)
          itemBuilder,
      Function(int index, T item)? clicked,
      Key? key}) {
    return JUIPageContainer(
      key: key,
      items: items,
      viewportFraction: viewportFraction,
      itemHeight: itemHeight,
      padding: padding,
      clicked: (index, item) {
        clicked?.call(index, item);
      },
      columnCount: columnCount,
      itemBuilder: ((context, index, item) {
        return itemBuilder(context, index, item);
      }),
    );
  }

  @override
  State<JUIPageContainer> createState() => _JUIPageContainerState();
}

class _JUIPageContainerState extends State<JUIPageContainer> {
  late PageController _pageController;
  var currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.items.length ~/ widget.columnCount;
    if (widget.items.length % widget.columnCount != 0) {
      itemCount += 1;
    }
    double height = widget.columnCount * (widget.itemHeight + widget.padding) -
        widget.padding;

    return LayoutBuilder(
      builder: ((p0, p1) {
        return Column(
          children: [
            SizedBox(
              width: p1.maxWidth,
              height: height,
              // margin: EdgeInsets.only(
              //     right: currentPage == widget.itemCount - 1 ? 40 : 0),
              child: PageView.builder(
                  itemCount: itemCount,
                  padEnds: currentPage == itemCount - 1,
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemBuilder: ((context, index) {
                    return Column(
                      children:
                          List.generate(widget.columnCount, (columnIndex) {
                        int currentIndex =
                            index * widget.columnCount + columnIndex;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: (() {
                                widget.clicked?.call(
                                    currentIndex, widget.items[currentIndex]);
                              }),
                              child: SizedBox(
                                height: widget.itemHeight,
                                child: widget.items.length > currentIndex
                                    ? widget.itemBuilder(context, currentIndex,
                                        widget.items[currentIndex])
                                    : null,
                              ),
                            ),
                            if (widget.padding > 0 &&
                                columnIndex != widget.columnCount - 1)
                              SizedBox(
                                height: widget.padding,
                              )
                          ],
                        );
                      }),
                    );
                  })),
            ),
            const SizedBox(
              height: 20,
            ),
            JUIPageControl(
              width: 40,
              height: 10,
              currentPage: currentPage,
              pageWidth: 5,
              currentPageWidth: 10,
              numberOfPages: itemCount,
              pageColor: const Color.fromRGBO(183, 187, 191, 0.4),
              tintColor: const Color.fromRGBO(183, 187, 191, 1),
            )
          ],
        );
      }),
    );
  }
}
