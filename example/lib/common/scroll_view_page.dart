import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

import '../list_button.dart';

class ScrollViewPage extends StatefulWidget {
  const ScrollViewPage({super.key});
  @override
  State<ScrollViewPage> createState() => _ScrollViewPageState();
}

class _ScrollViewPageState extends State<ScrollViewPage> {
  ScrollController scrollController0 = ScrollController();
  ScrollController scrollController1 = ScrollController();
  GlobalKey key0 = GlobalKey(),
      key1 = GlobalKey(),
      key2 = GlobalKey(),
      key3 = GlobalKey(),
      key4 = GlobalKey(),
      key5 = GlobalKey(),
      key6 = GlobalKey(),
      key7 = GlobalKey(),
      key9 = GlobalKey(),
      key8 = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScrollViewExtension'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: 200,
            width: 300,
            color: Colors.black.withAlpha(40),
            child: SingleChildScrollView(
              controller: scrollController0,
              key: key0,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ListButton(
                    title: '滚动到top加10间距',
                    key: key1,
                    onPressed: () {
                      scrollController0.scrollToKey(
                          scrollKey: key0,
                          targetKey: key1,
                          padding: 10,
                          scrollPosition:
                              ScrollControllerChildPosition.inScreen);
                    },
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  ListButton(
                    key: key9,
                    title: '滚动到屏幕内即可',
                    onPressed: () {
                      scrollController0.scrollToKey(
                          scrollKey: key0,
                          targetKey: key9,
                          scrollPosition:
                              ScrollControllerChildPosition.inScreen,
                          padding: 10);
                    },
                  ),
                  ListButton(
                    key: key3,
                    title: '滚动到center',
                    onPressed: () {
                      scrollController0.scrollToKey(
                        scrollKey: key0,
                        targetKey: key3,
                        scrollPosition: ScrollControllerChildPosition.center,
                      );
                    },
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  ListButton(
                    key: key2,
                    title: '滚动到bottom',
                    onPressed: () {
                      scrollController0.scrollToKey(
                        scrollKey: key0,
                        targetKey: key2,
                        scrollPosition: ScrollControllerChildPosition.bottom,
                      );
                    },
                  ),
                  SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 200,
            width: 300,
            color: Colors.black.withAlpha(20),
            child: SingleChildScrollView(
              controller: scrollController1,
              key: key4,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  ListButton(
                    height: 44,
                    title: '滚动到leading加10间距',
                    key: key5,
                    onPressed: () {
                      scrollController1.scrollToKey(
                          scrollKey: key4,
                          targetKey: key5,
                          scrollPosition: ScrollControllerChildPosition.leading,
                          padding: 10);
                    },
                  ),
                  SizedBox(
                    width: 200,
                  ),
                  ListButton(
                    height: 44,
                    key: key8,
                    title: '滚动到屏幕内即可',
                    onPressed: () {
                      scrollController1.scrollToKey(
                          scrollKey: key4,
                          targetKey: key8,
                          scrollPosition:
                              ScrollControllerChildPosition.inScreen);
                    },
                  ),
                  SizedBox(
                    width: 200,
                  ),
                  ListButton(
                    height: 44,
                    key: key6,
                    title: '滚动到center',
                    onPressed: () {
                      scrollController1.scrollToKey(
                          scrollKey: key4,
                          targetKey: key6,
                          scrollPosition: ScrollControllerChildPosition.center);
                    },
                  ),
                  SizedBox(
                    width: 200,
                  ),
                  ListButton(
                    height: 44,
                    key: key7,
                    title: '滚动到trailing',
                    onPressed: () {
                      scrollController1.scrollToKey(
                          scrollKey: key4,
                          targetKey: key7,
                          scrollPosition:
                              ScrollControllerChildPosition.traling);
                    },
                  ),
                  SizedBox(
                    width: 200,
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
