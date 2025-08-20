import 'package:flutter/material.dart';

import 'form_builder_field.dart';
import 'form_builder_field_option.dart';
import 'grouped_radio.dart';

/// Field to select one value from a list of Radio Widgets
class FormBuilderRadioGroup<T> extends FormBuilderField<T> {
  final Axis wrapDirection;
  final bool shouldRadioRequestFocus;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? focusColor;
  final Color? hoverColor;
  final ControlAffinity controlAffinity;
  final double wrapRunSpacing;
  final double spacing;
  final double textSpacing;
  final List<FormBuilderFieldOption<T>> options;
  final List<T>? disabled;
  final MaterialTapTargetSize? materialTapTargetSize;
  final OptionsOrientation orientation;
  final TextDirection? wrapTextDirection;
  final VerticalDirection wrapVerticalDirection;
  final Widget? separator;
  final WrapAlignment wrapAlignment;
  final WrapAlignment wrapRunAlignment;
  final WrapCrossAlignment wrapCrossAxisAlignment;

  /// Creates field to select one value from a list of Radio Widgets
  FormBuilderRadioGroup({
    super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled,
    super.focusNode,
    super.onSaved,
    super.validator,
    super.decoration,
    super.key,
    required this.options,
    super.initialValue,
    this.shouldRadioRequestFocus = false,
    this.activeColor,
    this.inactiveColor,
    this.controlAffinity = ControlAffinity.leading,
    this.disabled,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.orientation = OptionsOrientation.wrap,
    this.separator,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapDirection = Axis.horizontal,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 0.0,
    this.spacing = 0.0,
    this.textSpacing = 0.0,
    this.wrapTextDirection,
    this.wrapVerticalDirection = VerticalDirection.down,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
  }) : super(
          name: '',
          builder: (FormFieldState<T?> field) {
            final state = field as _FormBuilderRadioGroupState<T>;

            return GroupedRadio<T>(
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              controlAffinity: controlAffinity,
              disabled: state.enabled
                  ? disabled
                  : options.map((option) => option.value).toList(),
              focusColor: focusColor,
              hoverColor: hoverColor,
              materialTapTargetSize: materialTapTargetSize,
              onChanged: (value) {
                if (shouldRadioRequestFocus) {
                  state.requestFocus();
                }
                state.didChange(value);
              },
              options: options,
              orientation: orientation,
              separator: separator,
              value: state.value,
              wrapAlignment: wrapAlignment,
              wrapCrossAxisAlignment: wrapCrossAxisAlignment,
              wrapDirection: wrapDirection,
              wrapRunAlignment: wrapRunAlignment,
              wrapRunSpacing: wrapRunSpacing,
              wrapSpacing: spacing,
              textSpacing: textSpacing,
              wrapTextDirection: wrapTextDirection,
              wrapVerticalDirection: wrapVerticalDirection,
            );
          },
        );

  @override
  FormBuilderFieldState<FormBuilderRadioGroup<T>, T> createState() =>
      _FormBuilderRadioGroupState<T>();
}

class _FormBuilderRadioGroupState<T>
    extends FormBuilderFieldState<FormBuilderRadioGroup<T>, T> {}
