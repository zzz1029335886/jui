import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class ListLessonPage extends StatefulWidget {
  const ListLessonPage({super.key});

  @override
  State<ListLessonPage> createState() => _ListLessonPageState();
}

class _ListLessonPageState extends State<ListLessonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          JUISectionTitleContainer.defaultStyle(
            '主图在左',
            child: Column(
              children: List.generate(3, (index) {
                return Container(
                  child: JUISchoolListLesson(),
                  margin: EdgeInsets.symmetric(vertical: 8),
                );
              }),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          JUISectionTitleContainer.defaultStyle(
            '主图在上',
            moreCallbackAction: () {},
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(3, (index) {
                  return Container(
                    child: JUISchoolListLesson(
                      style: JUISchoolListLessonStyle.mainImgTop,
                    ),
                    margin: EdgeInsets.only(left: 8, top: 8),
                  );
                }),
              ),
            ),
          )
        ],
      )),
    );
  }
}
