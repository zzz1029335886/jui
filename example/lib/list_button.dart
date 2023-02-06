import 'package:flutter/material.dart';
import 'package:jui/jui.dart';

class ListButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const ListButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      child: JUIButton(
        title: title,
        onPressed: onPressed,
      ),
    );
  }
}
