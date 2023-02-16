import 'package:flutter/material.dart';

import 'jui_form_base.dart';

abstract class JUIFormContent extends JUIFormBase {
  final String? content;
  final TextStyle contentStyle;
  JUIFormContent(
      {super.key,
      required this.content,
      this.contentStyle = const TextStyle(),
      super.config,
      super.configBuilder});
}

// abstract class ZZFormContentCellState<T extends ZZFormContentCell>
//     extends ZZFormBaseCellState<T> {

//   @override
//   Widget contentBuild(BuildContext context) {
//     // TODO: implement contentBuild
//     throw UnimplementedError();
//   }
// }
