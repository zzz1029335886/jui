import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class JUIPageContainerPage extends StatefulWidget {
  const JUIPageContainerPage({super.key});

  @override
  State<JUIPageContainerPage> createState() => _JUIPageContainerPageState();
}

class _JUIPageContainerPageState extends State<JUIPageContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: JUIText('JUIPageContainer'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          JUIPageContainer.init(
              items: [1, 2, 3, 4, 5, 6, 7, 8, 9],
              itemHeight: 44,
              viewportFraction: 0.9,
              itemBuilder: (context, index, value) {
                return Container(
                  color: Colors.amberAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: Text('$value'),
                        color: Colors.amber,
                      ),
                    ],
                  ),
                );
              },
              columnCount: 3,
              padding: 10,
              clicked: (index, value) {})
        ],
      )),
    );
  }
}
