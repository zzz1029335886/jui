import 'package:flutter/material.dart';

import 'jui_form_base.dart';
import 'radio_group/form_builder_field.dart';
import 'radio_group/form_builder_field_option.dart';
import 'radio_group/form_builder_radio_group.dart';

typedef JUIFormRadioGroupOption<T> = FormBuilderFieldOption<T>;
typedef JUIFormRadioGroupOrientation = OptionsOrientation;

class JUIFormRadioConfig {
  final double spacing;
  final double textSpacing;
  final Color activeColor;
  final Color inactiveColor;
  final double wrapRunSpacing;
  final JUIFormRadioGroupOrientation orientation;

  JUIFormRadioConfig({
    this.spacing = 8.0,
    this.textSpacing = 8.0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.wrapRunSpacing = 8.0,
    this.orientation = OptionsOrientation.wrap,
  });
}

// ignore: must_be_immutable
class JUIFormRadioGroup<T> extends JUIFormBase {
  final List<JUIFormRadioGroupOption<T>> options;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final JUIFormRadioGroupOrientation? orientation;
  final double? spacing;
  final double? textSpacing;
  final double? wrapRunSpacing;
  final JUIFormRadioConfig? radioConfig;

  JUIFormRadioGroup({
    required this.options,
    this.initialValue,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.orientation,
    this.spacing,
    this.textSpacing,
    this.wrapRunSpacing,
    this.radioConfig,
    super.key,
    super.config,
    super.style,
    super.styleBuilder,
  });

  @override
  JUIFormBaseState<JUIFormRadioGroup> createState() =>
      _JUIFormRadioGroupState<T>();
}

class _JUIFormRadioGroupState<T>
    extends JUIFormBaseState<JUIFormRadioGroup<T>> {
  @override
  Widget contentBuild(BuildContext context) {
    var config = widget.radioConfig ?? formBuilderState?.widget.radioConfig;
    var content = FormBuilderRadioGroup<T>(
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      options: widget.options,
      activeColor: widget.activeColor ??
          config?.activeColor ??
          const Color.fromRGBO(129, 216, 208, 1),
      inactiveColor:
          widget.inactiveColor ?? config?.inactiveColor ?? Colors.grey,
      orientation:
          widget.orientation ?? config?.orientation ?? OptionsOrientation.wrap,
      spacing: widget.spacing ?? config?.spacing ?? 0,
      textSpacing: widget.textSpacing ?? config?.textSpacing ?? 0,
      wrapRunSpacing: widget.wrapRunSpacing ?? config?.wrapRunSpacing ?? 0,
      wrapVerticalDirection: VerticalDirection.down,
      controlAffinity: ControlAffinity.leading,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
      ),
    );
    if (isTopTitle) {
      return SizedBox(
        width: contentWidth,
        child: content,
      );
    } else {
      return Flexible(child: content);
    }
  }

  @override
  MainAxisAlignment? get mainAxisAlignment => MainAxisAlignment.spaceBetween;
}
