import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

enum JUISchoolListLessonStyle { mainImgLeft, mainImgTop }

class JUISchoolListLesson extends StatelessWidget {
  final JUISchoolListLessonStyle style;
  final Size mainImgSize;
  final Widget? customRightBottomWidget;
  final Widget? customPriceWidget;
  final int titleMaxLine;
  final bool? isShowTagRow;
  final bool isShowLecturer;
  final bool? isShowStudyNum;
  final bool? isShowOriginPrice;
  final bool isShowImageTopRightTag;
  final bool isShowImageBottom;
  final bool isShowPrice;
  final bool isShowLimitedTimeOffer;
  final bool isPushDetail;
  final bool isWithHorizontal;
  final Widget? imgBottomWidget;
  final CoursesBean? coursesBean;
  const JUISchoolListLesson(
      {super.key,
      this.coursesBean,
      this.customRightBottomWidget,
      this.customPriceWidget,
      this.titleMaxLine = 2,
      this.isShowTagRow,
      this.isShowLimitedTimeOffer = false,
      this.isPushDetail = true,
      this.isWithHorizontal = false,
      this.isShowStudyNum,
      this.isShowOriginPrice,
      this.isShowImageTopRightTag = true,
      this.isShowPrice = true,
      this.isShowImageBottom = true,
      this.isShowLecturer = false,
      this.imgBottomWidget,
      this.style = JUISchoolListLessonStyle.mainImgLeft,
      this.mainImgSize = const Size(128, 72)});

  bool get _isShowTagRow {
    return isShowTagRow ??
        false; //style == JUISchoolListLessonStyle.mainImgLeft;
  }

  bool get _isShowStudyNum {
    return isShowStudyNum ??
        true; // style == JUISchoolListLessonStyle.mainImgLeft;
  }

  bool get _isShowOriginPrice {
    return isShowOriginPrice ?? style == JUISchoolListLessonStyle.mainImgLeft;
  }

  Widget mainImg() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(229, 232, 235, 1),
              borderRadius: BorderRadius.all(Radius.circular(7))),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isShowImageTopRightTag
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(
                          '会员课',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(135, 84, 40, 1)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.5),
                        height: 20,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                              topRight: Radius.circular(7)),
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(252, 226, 185, 1),
                                Color.fromRGBO(246, 198, 126, 1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                        ),
                      ),
                    ],
                  )
                : Container(),
            if (isShowImageBottom)
              Container(
                alignment: Alignment.centerLeft,
                child: imgBottomWidget ??
                    Text(
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
    if (!isShowPrice) {
      return Container();
    }
    return Row(
      children: [
        if (style == JUISchoolListLessonStyle.mainImgLeft &&
            isShowLimitedTimeOffer)
          Container(
            padding:
                const EdgeInsets.only(left: 6, right: 6, bottom: 3, top: 2),
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
            child: const Text(
              '限时优惠',
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
        if (style == JUISchoolListLessonStyle.mainImgLeft)
          const SizedBox(
            width: 5,
          ),
        const Text(
          '￥99',
          style: TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(240, 20, 20, 1),
              fontWeight: FontWeight.w500),
        ),
        if (_isShowOriginPrice)
          Row(
            children: const [
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
          )
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

  Widget _lecturerWidget() {
    return Row(
      children: [
        Text(
          '解螺旋·酸菜  |  翡翠讲师',
          style:
              TextStyle(color: Color.fromRGBO(113, 119, 125, 1), fontSize: 12),
        ),
      ],
    );
  }

  Widget mainInfo() {
    return Container(
      height: style == JUISchoolListLessonStyle.mainImgTop
          ? null
          : mainImgSize.height,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              coursesBean != null
                  ? '${coursesBean?.title}'
                  : '医生做科研的最佳路医生做科研的最佳路医生做科研的生做科研的生做科研的最佳路医生做科研的最佳路医生做科研的最佳路医生做科研的最佳路',
              maxLines: titleMaxLine,
              style: const TextStyle(
                  color: Color.fromRGBO(49, 58, 67, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          if (_isShowTagRow)
            Column(
              children: [
                if (style == JUISchoolListLessonStyle.mainImgTop)
                  const SizedBox(
                    height: 12,
                  ),
                tagRow(),
              ],
            ),
          if (isShowLecturer)
            Column(
              children: [
                if (style == JUISchoolListLessonStyle.mainImgTop)
                  const SizedBox(
                    height: 12,
                  ),
                _lecturerWidget(),
              ],
            ),
          if (style == JUISchoolListLessonStyle.mainImgTop)
            const SizedBox(
              height: 12,
            ),
          _isShowStudyNum
              ? (customRightBottomWidget ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '5420人已学',
                        style: TextStyle(
                            color: Color.fromRGBO(147, 153, 159, 1),
                            fontSize: 12),
                      ),
                      customPriceWidget ?? priceWidget()
                    ],
                  ))
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
    Widget widget;
    if (style == JUISchoolListLessonStyle.mainImgLeft) {
      widget = rowStyle();
    } else {
      widget = columnStyle();
    }

    if (isPushDetail) {
      widget = InkWell(
        onTap: () {
          Get.toNamed('SchoolLessonDetail',
              arguments: coursesBean?.uuid, preventDuplicates: false);
        },
        child: widget,
      );
    }
    return Container(
      padding:
          isWithHorizontal ? const EdgeInsets.symmetric(horizontal: 16) : null,
      child: widget,
    );
  }
}
