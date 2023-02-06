import 'package:flutter/material.dart';

import 'jui_form_base.dart';

abstract class JUIFormContent extends JUIFormBase {
  final String? content;
  final TextStyle contentStyle;
  const JUIFormContent(
      {super.key,
      required this.content,
      this.contentStyle = const TextStyle(),
      required super.config});
}

// abstract class ZZFormContentCellState<T extends ZZFormContentCell>
//     extends ZZFormBaseCellState<T> {

//   @override
//   Widget contentBuild(BuildContext context) {
//     // TODO: implement contentBuild
//     throw UnimplementedError();
//   }
// }
