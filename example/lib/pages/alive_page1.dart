/*
 * @Author: -zerry- zzz1029335886@qq.com
 * @Date: 2023-03-08 15:42:44
 * @LastEditors: -zerry- zzz1029335886@qq.com
 * @LastEditTime: 2023-03-08 15:46:57
 * @FilePath: /jieluoxuan_ui-components/example/lib/pages/alive_page1.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';

class AlivePage1 extends StatefulWidget {
  const AlivePage1({super.key});
  @override
  State<AlivePage1> createState() => _AlivePage1State();
}

class _AlivePage1State extends State<AlivePage1>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(
        children: List.generate(
            100,
            (index) => ListTile(
                  title: Text('$index'),
                )),
      ),
    );
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('$index'),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
