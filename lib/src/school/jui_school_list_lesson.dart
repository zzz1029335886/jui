import 'package:flutter/material.dart';

enum JUISchoolListLessonStyle { mainImgLeft, mainImgTop }

class JUISchoolListLesson extends StatelessWidget {
  final JUISchoolListLessonStyle style;
  final Size mainImgSize;
  const JUISchoolListLesson(
      {super.key,
      this.style = JUISchoolListLessonStyle.mainImgLeft,
      this.mainImgSize = const Size(128, 72)});

  Widget mainImg() {
    return Stack(
      // alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(229, 232, 235, 1),
              borderRadius: BorderRadius.all(Radius.circular(7))),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(child: Text('')),
                Container(
                  child: Text(
                    '会员课',
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(135, 84, 40, 1)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.5),
                  height: 20,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(7),
                        topRight: Radius.circular(7)),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(252, 226, 185, 1),
                      Color.fromRGBO(246, 198, 126, 1),
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '会员课',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 20,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(7),
                    topRight: Radius.circular(7)),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(0, 0, 0, 0.2),
                  Color.fromRGBO(0, 0, 0, 0),
                ], begin: Alignment.centerLeft, end: Alignment.centerRight),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget priceWidget() {
    return Row(
      children: [
        if (style == JUISchoolListLessonStyle.mainImgLeft)
          Container(
            child: Text(
              '限时优惠',
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
            padding: EdgeInsets.only(left: 6, right: 6, bottom: 3, top: 2),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(9),
                  bottomLeft: Radius.circular(9),
                  topRight: Radius.circular(9)),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(255, 74, 71, 1),
                Color.fromRGBO(255, 110, 106, 1),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
        style == JUISchoolListLessonStyle.mainImgLeft
            ? SizedBox(
                width: 5,
              )
            : Expanded(child: Text('')),
        Text(
          '￥99',
          style: TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(240, 20, 20, 1),
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          '￥199',
          style: TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(147, 153, 159, 1),
              decoration: TextDecoration.lineThrough),
        ),
      ],
    );
  }

  Widget tagRow() {
    return Row(
      children: [
        Text(
          '基础科研',
          style:
              TextStyle(color: Color.fromRGBO(113, 119, 125, 1), fontSize: 12),
        ),
        SizedBox(
          width: 12,
        ),
        Text(
          '初阶',
          style:
              TextStyle(color: Color.fromRGBO(113, 119, 125, 1), fontSize: 12),
        ),
      ],
    );
  }

  Widget mainInfo() {
    return Container(
      height: this.style == JUISchoolListLessonStyle.mainImgTop
          ? null
          : this.mainImgSize.height,
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '医生做科研的最佳路医生做科研的最佳路医生做科研的生做科研的生做科研的最佳路医生做科研的最佳路医生做科研的最佳路医生做科研的最佳路',
              maxLines: 2,
              style: TextStyle(
                  color: Color.fromRGBO(49, 58, 67, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          if (mainImgSize.height > 80)
            Column(
              children: [
                if (style == JUISchoolListLessonStyle.mainImgTop)
                  SizedBox(
                    height: 12,
                  ),
                tagRow(),
              ],
            ),
          if (style == JUISchoolListLessonStyle.mainImgTop)
            SizedBox(
              height: 12,
            ),
          style == JUISchoolListLessonStyle.mainImgLeft
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5420人已学',
                      style: TextStyle(
                          color: Color.fromRGBO(147, 153, 159, 1),
                          fontSize: 12),
                    ),
                    priceWidget()
                  ],
                )
              : priceWidget()
        ],
      ),
    );
  }

  Widget rowStyle() {
    return Row(
      children: [
        Container(
          child: mainImg(),
          height: mainImgSize.height,
          width: mainImgSize.width,
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: mainInfo(),
        )
      ],
    );
  }

  Widget columnStyle() {
    return Container(
      width: mainImgSize.width,
      child: Column(
        children: [
          Container(
            child: mainImg(),
            height: mainImgSize.height,
          ),
          SizedBox(
            height: 12,
          ),
          mainInfo()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (style == JUISchoolListLessonStyle.mainImgLeft) {
      return rowStyle();
    } else {
      return columnStyle();
    }
  }
}
