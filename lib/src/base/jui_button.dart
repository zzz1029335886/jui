import 'package:flutter/material.dart';

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
  final Widget? text;
  final double? iconSize;
  final double middlePadding;

  const JUIButton(
      {this.onPressed,
      this.labelPostion = JUIButtonLabelPostion.labelRight,
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
      this.text,
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
      if (text != null) text!,
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

    Widget child = _child(
      children: children,
    );

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0), //内边距
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, //外边距
      ),
      onPressed: onPressed,
      child: isOneWidget ? children.first : Container(child: child),
    );
  }

  get isOneWidget =>
      (icon == null && iconWidget == null) && (title != null || text != null) ||
      (icon != null || iconWidget != null) && title == null && text == null;
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
      {required VoidCallback onPressed,
      String? title,
      Color? color = const Color.fromRGBO(147, 153, 159, 1)}) {
    return TextButton(
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

  static Widget customButton(
      {required VoidCallback onPressed,
      String? title,
      double? width,
      EdgeInsets? padding,
      EdgeInsets? margin,
      double? height,
      Color? titleColor = Colors.white,
      double? radius,
      Color? backgroundColor = const Color.fromRGBO(129, 216, 208, 1)}) {
    return Container(
      width: width,
      padding: padding,
      margin: margin,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: radius != null
              ? BorderRadius.all(Radius.circular(radius))
              : null),
      child: JUIButton(
        title: title,
        color: titleColor,
        onPressed: onPressed,
      ),
    );
  }
}
