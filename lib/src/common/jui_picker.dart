///  jh_picker_tool.dart
///
///  Created by iotjin on 2020/02/17.
///  description:  底部选择器 包含日期，单列、多列文本

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

const String _titleNormalText = '';
const String _cancelText = '取消';
const String _confirmText = '确定';
const String _yearSuffix = '年';
const String _monthSuffix = '月';
const String _daySuffix = '日';
const List<String> _strAMPM = ['上午', '下午'];
const double _kPickerHeight = 280.0;
const double _kItemHeight = 50.0;
const double _kHeaderLineHeight = 0.25;
const double _kHeaderRadius = 10.0;
const double _kTitleFontSize = 18.0;
const double _kBtnFontSize = 15.0;
const double _selectTextFontSize = 16.0;

/// 选择回调
/// 单列选择器返回选中行对象和index
/// 多列选择器返回选中行对象数组和index数组
/// 时间选择器返回选中行时间（时间格式：2022-07-03 15:00:46）和index数组
typedef JUIPickerClickCallBack = void Function(
    dynamic selectValue, dynamic selectIndexArr);

enum JUIPickerDateType {
  ymd, // y, m, d
  ym, // y ,m
  ymdhm, // y, m, d, hh, mm
  ymdaphm, // y, m, d, ap, hh, mm
}

enum JUIPickerType {
  string,
  array,
  date,
}

class JUIPicker {
  /// 单列
  static void showStringPicker(
    BuildContext context, {
    required List data,
    String? title,
    String? labelKey, // 对象数组的文字字段
    int selectIndex = 0,
    required void Function(String selectValue, int selectIndexArr)?
        clickCallBack,
  }) {
    if (data.isEmpty) {
      return;
    }
    _showPicker(
      context,
      data: data,
      title: title,
      selecteds: [selectIndex],
      pickerType: JUIPickerType.string,
      adapter: labelKey != null
          ? PickerDataAdapter(pickerData: data.map((e) => e[labelKey]).toList())
          : PickerDataAdapter(pickerData: data),
      clickCallBack: (selectValue, selectIndexArr) {
        clickCallBack?.call(selectValue, selectIndexArr);
      },
    );
  }

  /// 多列
  static void showArrayPicker<T>(
    BuildContext context, {
    required List data,
    String? title,
    String? labelKey, // 对象数组的文字字段
    List<int>? selectIndex,
    required JUIPickerClickCallBack clickCallBack,
  }) {
    if (data.isEmpty) {
      return;
    }
    _showPicker(
      context,
      data: data,
      title: title,
      selecteds: selectIndex,
      pickerType: JUIPickerType.array,
      adapter: labelKey != null
          ? PickerDataAdapter(
              pickerData: data.map((e) {
                return e.map((e2) => e2[labelKey]).toList();
              }).toList(),
              isArray: true)
          : PickerDataAdapter(pickerData: data, isArray: true),
      clickCallBack: clickCallBack,
    );
  }

  /// 日期选择器
  static void showDatePicker(
    BuildContext context, {
    String? title,
    JUIPickerDateType? dateType,
    DateTime? maxTime,
    DateTime? minTime,
    DateTime? selectTime,
    int? yearBegin = 1900,
    int? yearEnd = 2100,
    int? minHour = 0,
    int? maxHour = 23,
    required JUIPickerClickCallBack clickCallBack,
  }) {
    int timeType;
    if (dateType == JUIPickerDateType.ym) {
      timeType = PickerDateTimeType.kYM;
    } else if (dateType == JUIPickerDateType.ymdhm) {
      timeType = PickerDateTimeType.kYMDHM;
    } else if (dateType == JUIPickerDateType.ymdaphm) {
      timeType = PickerDateTimeType.kYMD_AP_HM;
    } else {
      timeType = PickerDateTimeType.kYMD;
    }

    _showPicker(
      context,
      title: title,
      pickerType: JUIPickerType.date,
      adapter: DateTimePickerAdapter(
        type: timeType,
        isNumberMonth: true,
        yearSuffix: _yearSuffix,
        monthSuffix: _monthSuffix,
        daySuffix: _daySuffix,
        strAMPM: _strAMPM,
        maxValue: maxTime,
        minValue: minTime,
        value: selectTime ?? DateTime.now(),
        minHour: minHour,
        maxHour: maxHour,
        yearBegin: yearBegin,
        yearEnd: yearEnd,
      ),
      clickCallBack: clickCallBack,
    );
  }
}

/// 自定义picker
_showPicker<T>(
  context, {
  required PickerAdapter adapter,
  List? data,
  String? title,
  List<int>? selecteds,
  JUIPickerType? pickerType,
  JUIPickerClickCallBack? clickCallBack,
}) {
  // 默认颜色
  var isDark = Theme.of(context).brightness == Brightness.dark;
  var _bgColor = Colors.white; // const Color.fromRGBO(0, 0, 0,0.5);
  //isDark ? KColors.kPickerBgDarkColor : KColors.kPickerBgColor;
  var _headerColor = Colors.white;
  //isDark ? KColors.kPickerHeaderDarkColor : KColors.kPickerHeaderColor;
  var _kHeaderLineColor = Color.fromRGBO(235, 239, 242, 1);
  // isDark ? KColors.kPickerHeaderLineDarkColor : KColors.kPickerHeaderLineColor;
  var _titleColor = Colors.black;
  //isDark ? KColors.kPickerTitleDarkColor : KColors.kPickerTitleColor;
  var _btnColor = Color.fromRGBO(129, 216, 208, 1);
  //isDark ? KColors.kPickerBtnDarkColor : KColors.kPickerBtnColor;
  var _selectTextColor = Color.fromRGBO(49, 58, 67, 1);
  //isDark ? KColors.kPickerTextDarkColor : KColors.kPickerTextColor;
  var _selectItemBgColor = Colors.grey.withOpacity(0.15);

  var picker = Picker(
      adapter: adapter,
      selecteds: selecteds,
      height: _kPickerHeight,
      itemExtent: _kItemHeight,
      title: Text(title ?? _titleNormalText,
          style: TextStyle(color: _titleColor, fontSize: _kTitleFontSize)),
      cancelText: _cancelText,
      cancelTextStyle: const TextStyle(
          color: Color.fromRGBO(147, 153, 159, 1), fontSize: _kBtnFontSize),
      confirmText: _confirmText,
      confirmTextStyle: TextStyle(color: _btnColor, fontSize: _kBtnFontSize),
      textAlign: TextAlign.center,
      textStyle: const TextStyle(
          color: Color.fromRGBO(147, 153, 159, 1), fontSize: 14),
      selectedTextStyle:
          TextStyle(color: _selectTextColor, fontSize: _selectTextFontSize),
      selectionOverlay:
          Container(height: _kItemHeight, color: _selectItemBgColor),
      backgroundColor: _bgColor,
      headerDecoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: _kHeaderLineColor, width: _kHeaderLineHeight),
        ),
      ),
      onConfirm: (Picker picker, List selectIndexArr) {
        if (pickerType == JUIPickerType.string) {
          var selectIndex = selectIndexArr[0];
          clickCallBack?.call(data![selectIndex], selectIndex);
        }
        if (pickerType == JUIPickerType.array) {
          var selectItemArr = [];
          for (int i = 0; i < selectIndexArr.length; i++) {
            int j = selectIndexArr[i];
            selectItemArr.add(data![i][j]);
          }
          clickCallBack?.call(selectItemArr, selectIndexArr);
        }
        if (pickerType == JUIPickerType.date) {
          // var time = (picker.adapter as DateTimePickerAdapter).value;
          clickCallBack?.call(
              picker.adapter.text.split('.')[0], selectIndexArr);
        }
      });

  picker.showModal(context, backgroundColor: Colors.transparent,
      builder: (context, view) {
    return Material(
        color: _headerColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(_kHeaderRadius),
            topRight: Radius.circular(_kHeaderRadius)),
        child: Container(
          padding: const EdgeInsets.only(top: 5),
          child: view,
        ));
  });
}
