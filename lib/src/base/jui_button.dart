import 'dart:math';

import 'package:flutter/material.dart';

import 'jui_enabled.dart';

enum JUIButtonLabelPostion { labelTop, labelBottom, labelLeft, labelRight }

class JUIButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final JUIButtonLabelPostion labelPostion;
  final IconData? icon;
  final Widget? iconWidget;
  final Color? color;
  final Color? tintColor;
  final String? title;
  final Color? titleColor;
  final TextAlign? titleAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? child;
  final double? iconSize;
  final double middlePadding;
  final bool isEnabled;
  final EdgeInsets padding;
  final String? badgeValue;
  final double badgeHeight;
  final int? maxLines;

  const JUIButton(
      {this.onPressed,
      this.labelPostion = JUIButtonLabelPostion.labelRight,
      this.isEnabled = true,
      this.icon,
      this.iconWidget,
      this.iconSize,
      this.badgeValue,
      this.badgeHeight = 16,
      this.padding = EdgeInsets.zero,
      this.color,
      this.tintColor,
      this.title,
      this.maxLines,
      this.titleColor,
      this.titleAlign,
      this.middlePadding = 8,
      this.fontSize,
      this.fontWeight,
      this.child,
      super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      if (iconWidget != null) iconWidget!,
      if (icon != null)
        Icon(
          icon,
          color: tintColor ?? color,
          size: iconSize,
        ),
      if (!isOneWidget)
        SizedBox(
          width: isVertical ? null : middlePadding,
          height: isVertical ? middlePadding : null,
        ),
      if (child != null) child!,
      if (title != null)
        Text(
          title!,
          textAlign: titleAlign,
          maxLines: maxLines,
          style: TextStyle(
              color: titleColor ?? tintColor ?? color,
              fontSize: fontSize,
              fontWeight: fontWeight),
        )
    ];

    Widget showChild = _child(
      children: children,
    );

    Widget finalWidget =
        isOneWidget ? children.first : Container(child: showChild);
    Widget button = JUIEnabled(
      isEnabled: isEnabled,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0), //内边距
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, //外边距
        ),
        onPressed: onPressed,
        child: Container(
          padding: padding,
          child: finalWidget,
        ),
      ),
    );
    if (badgeValue == null) {
      return button;
    }

    var badgeStyle = const TextStyle(fontSize: 12, color: Colors.white);
    var badgeWidget = Text(
      badgeValue!,
      style: badgeStyle,
    );
    var layout = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: badgeValue, style: badgeStyle))
      ..layout();
    double badgeWidth = max(layout.width, badgeHeight);

    return Stack(
      children: [
        button,
        Positioned(
            right: 0,
            top: 0,
            child: Transform.translate(
              offset: Offset(badgeWidth * 0.5, -badgeHeight * 0.5),
              child: Container(
                  constraints: BoxConstraints(
                    minHeight: badgeHeight,
                    maxHeight: badgeHeight,
                    minWidth: badgeHeight,
                  ),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 20, 20, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: badgeWidget),
            ))
      ],
    );
  }

  get isOneWidget =>
      (icon == null && iconWidget == null) &&
          (title != null || child != null) ||
      (icon != null || iconWidget != null) && title == null && child == null;
  get isVertical =>
      labelPostion == JUIButtonLabelPostion.labelBottom ||
      labelPostion == JUIButtonLabelPostion.labelTop;

  Widget _child({required List<Widget> children}) {
    if (isVertical) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: labelPostion == JUIButtonLabelPostion.labelBottom
            ? children
            : children.reversed.toList(),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: labelPostion == JUIButtonLabelPostion.labelRight
            ? children
            : children.reversed.toList(),
      );
    }
  }

  static Widget moreButton(
      {required VoidCallback? onPressed,
      String? title,
      Color? color = const Color.fromRGBO(147, 153, 159, 1)}) {
    return JUIButton(
        onPressed: onPressed,
        child: Row(
          children: [
            if (title != null)
              Text(
                title,
                style: TextStyle(color: color, fontSize: 12),
              ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 11,
            )
          ],
        ));
  }

  static Widget themeBorder({
    VoidCallback? onPressed,
    double? radius = 7,
    double? height = 44,
    String? title,
    int? maxLines,
    bool isEnabled = true,
  }) {
    return JUIButton.custom(
        isEnabled: isEnabled,
        borderColor: const Color.fromRGBO(129, 216, 208, 1),
        radius: radius,
        titleColor: const Color.fromRGBO(129, 216, 208, 1),
        height: height,
        onPressed: onPressed,
        title: title,
        maxLines: maxLines);
  }

  static Widget themeBackground(
      {VoidCallback? onPressed,
      double? width,
      EdgeInsets? padding,
      EdgeInsets? margin,
      bool isEnabled = true,
      String? title,
      int? maxLines,
      double? radius = 7,
      double? fontSize = 16,
      double? height = 44,
      Color? backgroundColor = const Color.fromRGBO(129, 216, 208, 1),
      bool isShowOnAppBar = false}) {
    return custom(
        onPressed: onPressed,
        width: width,
        padding: padding,
        isEnabled: isEnabled,
        margin: margin,
        height: height,
        fontSize: fontSize,
        radius: radius,
        backgroundColor: backgroundColor,
        isShowOnAppBar: isShowOnAppBar,
        maxLines: maxLines,
        title: title);
  }

  static Widget pageBottomButtons({
    required List<Widget> widgets,
    VoidCallback? onPressed,
    double? height = 56,
  }) {
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: 0.5,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: widgets,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget pageBottomButton({
    required String title,
    bool isEnabled = true,
    VoidCallback? onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          height: 0.5,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: JUIButton.themeBackground(
            onPressed: onPressed,
            isEnabled: isEnabled,
            title: title,
          ),
        ),
      ],
    );
  }

  static Widget custom(
      {Key? key,
      Color? color,
      VoidCallback? onPressed,
      String? title,
      int? maxLines,
      IconData? icon,
      double? iconSize,
      Widget? iconWidget,
      Color? tintColor,
      double? width,
      Widget? clild,
      EdgeInsets? padding,
      EdgeInsets? margin,
      double? height,
      double middlePadding = 8,
      bool isEnabled = true,
      Color? titleColor = Colors.white,
      double? fontSize,
      FontWeight? fontWeight,
      double? radius,
      Color? borderColor,
      double borderWidth = 0.5,
      Color? backgroundColor,
      String? badgeValue,
      double badgeHeight = 16,
      bool isShowOnAppBar = false}) {
    var _padding = padding;
    // if (isShowOnAppBar && padding == null) {
    //   _padding = const EdgeInsets.only(right: 16);
    // }

    Widget res = Container(
      width: width,
      padding: _padding,
      margin: margin,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: borderColor != null
              ? Border.all(color: borderColor, width: borderWidth)
              : null,
          borderRadius: radius != null
              ? BorderRadius.all(Radius.circular(radius))
              : null),
      child: JUIButton(
        title: title,
        maxLines: maxLines,
        color: titleColor ?? color,
        middlePadding: middlePadding,
        badgeValue: badgeValue,
        badgeHeight: badgeHeight,
        icon: icon,
        iconSize: iconSize,
        iconWidget: iconWidget,
        tintColor: tintColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        onPressed: _padding == null ? onPressed : null,
        child: clild,
      ),
    );

    if (_padding != null) {
      res = InkWell(
        onTap: onPressed,
        child: res,
      );
    }

    if (isShowOnAppBar) {
      res = Row(
        children: [
          res,
          SizedBox(
            width: 16,
          )
        ],
      );
    }

    return JUIEnabled(
      isEnabled: isEnabled,
      key: key,
      child: res,
    );
  }
}
