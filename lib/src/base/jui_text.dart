import 'package:flutter/material.dart';

class JUIText extends StatelessWidget {
  final String title;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;

  const JUIText(this.title,
      {this.color,
      this.maxLines,
      this.fontSize = 16,
      this.fontWeight,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
