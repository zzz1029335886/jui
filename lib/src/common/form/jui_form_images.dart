// import 'package:dd_js_util/dd_js_util.dart';
// import 'package:flutter/material.dart';

// import 'zz_form_base_cell.dart';


// class ZZFormImagesCell extends ZZFormBaseCell {
//   final int columnCount;
//   final bool isUpload;
//   final bool isMultiplePick;
//   final int maxCount;
//   final double spacing;
//   final double runSpacing;

//   const ZZFormImagesCell(
//       {super.key,
//       this.spacing = 10,
//       this.runSpacing = 10,
//       this.maxCount = 9,
//       this.columnCount = 3,
//       this.isUpload = false,
//       this.isMultiplePick = true,
//       required super.config});

//   @override
//   ZZFormBaseCellState<ZZFormBaseCell> createState() => _ZZFormImagesCellState();
// }

// class _ZZFormImagesCellState extends ZZFormBaseCellState<ZZFormImagesCell> {
//   late PictureSelectionController controller;

//   @override
//   void initState() {
//     super.initState();

//     controller = PictureSelectionController();
//   }

//   @override
//   Widget contentBuild(BuildContext context) {
//     var itemWidth =
//         (contentWidth - (widget.columnCount - 1).toDouble() * widget.spacing) /
//             widget.columnCount.toDouble();

//     if (widget.isUpload) {
//       return SizedBox(
//         width: contentWidth,
//         child: PictureSelection(
//           columnCount: widget.columnCount,
//           padding: EdgeInsets.zero,
//           mainAxisSpacing: widget.spacing,
//           crossAxisSpacing: widget.runSpacing,
//           multipleChoice: widget.isMultiplePick,
//           maxCount: widget.maxCount,
//           controller: controller,
//         ),
//       );
//     } else {
//       return SizedBox(
//         width: contentWidth,
//         child: Wrap(
//           spacing: widget.spacing,
//           runSpacing: widget.runSpacing,
//           alignment: WrapAlignment.start,
//           children: List.generate(widget.maxCount, (index) {
//             return Container(
//               width: itemWidth,
//               height: itemWidth,
//               color: Colors.amber,
//             );
//           }),
//         ),
//       );
//     }
//   }
// }
