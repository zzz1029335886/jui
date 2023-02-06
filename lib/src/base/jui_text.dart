import 'package:flutter/material.dart';

Color rgba(int r, int g, int b, double a) {
  return Color.fromRGBO(r, g, b, a);
}

class JUIText extends StatelessWidget {
  final String title;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;

  const JUIText(this.title,
      {this.color, this.maxLines, this.fontSize, this.fontWeight, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight,
      ),
    );
  }
}
