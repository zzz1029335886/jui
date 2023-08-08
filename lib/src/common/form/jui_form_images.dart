import 'package:flutter/material.dart';

import '../../other/cf_picture_selection.dart';
import 'jui_form.dart';

class JUIFormImages extends JUIFormBase {
  final int columnCount;
  final bool isUpload;
  final bool isMultiplePick;
  final int maxCount;
  final double spacing;
  final double runSpacing;
  final PictureSelectionController? controller;

  JUIFormImages({
    super.key,
    this.spacing = 10,
    this.runSpacing = 10,
    this.maxCount = 9,
    this.columnCount = 3,
    this.isUpload = false,
    this.isMultiplePick = true,
    this.controller,
    super.config,
    super.style,
    super.styleBuilder,
  });

  @override
  JUIFormBaseState<JUIFormBase> createState() => _JUIFormImagesState();
}

class _JUIFormImagesState extends JUIFormBaseState<JUIFormImages> {
  late PictureSelectionController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? PictureSelectionController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget contentBuild(BuildContext context) {
    var itemWidth =
        (contentWidth - (widget.columnCount - 1).toDouble() * widget.spacing) /
            widget.columnCount.toDouble();

    if (widget.isUpload) {
      return SizedBox(
        width: contentWidth,
        child: PictureSelection(
          columnCount: widget.columnCount,
          mainAxisSpacing: widget.spacing,
          crossAxisSpacing: widget.runSpacing,
          multipleChoice: widget.isMultiplePick,
          maxCount: widget.maxCount,
          controller: controller,
        ),
      );
    } else {
      return SizedBox(
        width: contentWidth,
        child: Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          alignment: WrapAlignment.start,
          children: List.generate(widget.maxCount, (index) {
            return Container(
              width: itemWidth,
              height: itemWidth,
              color: Colors.amber,
            );
          }),
        ),
      );
    }
  }
}
