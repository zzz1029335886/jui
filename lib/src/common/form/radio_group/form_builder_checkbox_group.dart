import 'package:flutter/material.dart';

import 'form_builder_field.dart';
import 'form_builder_field_option.dart';
import 'grouped_checkbox.dart';

/// A list of Checkboxes for selecting multiple options
class FormBuilderCheckboxGroup<T> extends FormBuilderField<List<T>> {
  final List<FormBuilderFieldOption<T>> options;
  final Color? activeColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final List<T>? disabled;
  final MaterialTapTargetSize? materialTapTargetSize;
  final bool tristate;
  final Axis wrapDirection;
  final WrapAlignment wrapAlignment;
  final double wrapSpacing;
  final WrapAlignment wrapRunAlignment;
  final double wrapRunSpacing;
  final WrapCrossAlignment wrapCrossAxisAlignment;
  final TextDirection? wrapTextDirection;
  final VerticalDirection wrapVerticalDirection;
  final Widget? separator;
  final ControlAffinity controlAffinity;
  final OptionsOrientation orientation;
  final bool shouldRequestFocus;

  /// Creates a list of Checkboxes for selecting multiple options
  FormBuilderCheckboxGroup({
    super.key,
    super.validator,
    super.initialValue,
    super.decoration,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    required this.options,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.disabled,
    this.materialTapTargetSize,
    this.tristate = false,
    this.wrapDirection = Axis.horizontal,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapSpacing = 0.0,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 0.0,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapTextDirection,
    this.wrapVerticalDirection = VerticalDirection.down,
    this.separator,
    this.controlAffinity = ControlAffinity.leading,
    this.orientation = OptionsOrientation.wrap,
    this.shouldRequestFocus = false,
  }) : super(
          name: '',
          builder: (FormFieldState<List<T>?> field) {
            final state = field as _FormBuilderCheckboxGroupState<T>;

            return InputDecorator(
              decoration: state.decoration,
              child: GroupedCheckbox<T>(
                orientation: orientation,
                value: state.value,
                options: options,
                onChanged: (val) {
                  if (shouldRequestFocus) {
                    state.requestFocus();
                  }
                  field.didChange(val);
                },
                disabled: state.enabled
                    ? disabled
                    : options.map((e) => e.value).toList(),
                activeColor: activeColor,
                focusColor: focusColor,
                checkColor: checkColor,
                materialTapTargetSize: materialTapTargetSize,
                hoverColor: hoverColor,
                tristate: tristate,
                wrapAlignment: wrapAlignment,
                wrapCrossAxisAlignment: wrapCrossAxisAlignment,
                wrapDirection: wrapDirection,
                wrapRunAlignment: wrapRunAlignment,
                wrapRunSpacing: wrapRunSpacing,
                wrapSpacing: wrapSpacing,
                wrapTextDirection: wrapTextDirection,
                wrapVerticalDirection: wrapVerticalDirection,
                separator: separator,
                controlAffinity: controlAffinity,
              ),
            );
          },
        );

  @override
  FormBuilderFieldState<FormBuilderCheckboxGroup<T>, List<T>> createState() =>
      _FormBuilderCheckboxGroupState<T>();
}

class _FormBuilderCheckboxGroupState<T>
    extends FormBuilderFieldState<FormBuilderCheckboxGroup<T>, List<T>> {}
