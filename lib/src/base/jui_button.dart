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
  final TextAlign? titleAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? child;
  final double? iconSize;
  final double middlePadding;
  final bool isEnabled;

  const JUIButton(
      {this.onPressed,
      this.labelPostion = JUIButtonLabelPostion.labelRight,
      this.isEnabled = true,
      this.icon,
      this.iconWidget,
      this.iconSize,
      this.color = const Color.fromRGBO(49, 58, 67, 1),
      this.tintColor,
      this.title,
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
          style: TextStyle(
              color: tintColor ?? color,
              fontSize: fontSize,
              fontWeight: fontWeight),
        )
    ];

    Widget showChild = _child(
      children: children,
    );

    return JUIEnabled(
      isEnabled: isEnabled,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0), //内边距
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, //外边距
        ),
        onPressed: onPressed,
        child: isOneWidget ? children.first : Container(child: showChild),
      ),
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
    bool isEnabled = true,
  }) {
    return JUIButton.custom(
        isEnabled: isEnabled,
        borderColor: const Color.fromRGBO(129, 216, 208, 1),
        radius: radius,
        titleColor: const Color.fromRGBO(129, 216, 208, 1),
        height: height,
        onPressed: onPressed,
        title: title);
  }

  static Widget themeBackground(
      {VoidCallback? onPressed,
      double? width,
      EdgeInsets? padding,
      EdgeInsets? margin,
      bool isEnabled = true,
      String? title,
      double? radius = 7,
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
        radius: radius,
        backgroundColor: backgroundColor,
        isShowOnAppBar: isShowOnAppBar,
        title: title);
  }

  static Widget pageBottomButtons({
    required List<Widget> widgets,
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
          child: Row(
            children: widgets,
          ),
        ),
      ],
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
      VoidCallback? onPressed,
      String? title,
      IconData? icon,
      Color? tintColor,
      double? width,
      Widget? clild,
      EdgeInsets? padding,
      EdgeInsets? margin,
      double? height,
      bool isEnabled = true,
      Color? titleColor = Colors.white,
      double? fontSize,
      double? radius,
      Color? borderColor,
      Color? backgroundColor,
      bool isShowOnAppBar = false}) {
    var _padding = padding;
    if (isShowOnAppBar && padding == null) {
      _padding = const EdgeInsets.only(right: 16);
    }

    Widget res = Container(
      width: width,
      padding: _padding,
      margin: margin,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: borderColor != null ? Border.all(color: borderColor) : null,
          borderRadius: radius != null
              ? BorderRadius.all(Radius.circular(radius))
              : null),
      child: JUIButton(
        title: title,
        color: titleColor,
        icon: icon,
        tintColor: tintColor,
        fontSize: fontSize,
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

    return JUIEnabled(
      isEnabled: isEnabled,
      key: key,
      child: res,
    );
  }
}
