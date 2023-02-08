import 'package:example/school/list_lesson_page.dart';
import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

import '../list_button.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({super.key});

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: JUIText('学院'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListButton(
            title: 'ListLesson',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ListLessonPage();
              }));
            },
          ),
        ],
      )),
    );
  }
}
