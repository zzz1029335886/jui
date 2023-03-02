import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class ListButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final VoidCallback onPressed;
  const ListButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      this.width,
      this.height = 44})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JUIButton(
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        // color: randomColor(),
        child: JUIText(title),
      ),
      onPressed: onPressed,
    );
  }

  int random(int min, int max) {
    final _random = Random();
    return min + _random.nextInt(max - min + 1);
  }

  Color randomColor() {
    return Color.fromARGB(
        random(150, 255), random(0, 255), random(0, 255), random(0, 255));
  }
}
