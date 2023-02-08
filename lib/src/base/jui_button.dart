import 'package:flutter/material.dart';

import 'jui_text.dart';

enum JUIButtonLabelPostion { labelTop, labelBottom, labelLeft, labelRight }

class JUIButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final JUIButtonLabelPostion labelPostion;
  final IconData? icon;
  final Color? color;
  final Color? tintColor;
  final String? title;
  final TextAlign? titleAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final JUIText? text;
  final double? iconSize;
  final double middlePadding;

  const JUIButton(
      {this.onPressed,
      this.labelPostion = JUIButtonLabelPostion.labelRight,
      this.icon,
      this.iconSize,
      this.color,
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
      child: isOneWidget ? children.first : Expanded(child: child),
    );
  }

  get isOneWidget =>
      icon == null && (title != null || text != null) ||
      icon != null && title == null && text == null;
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
}
