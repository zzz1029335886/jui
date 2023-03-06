import 'package:flutter/material.dart';

import 'form_builder_field.dart';
import 'grouped_radio.dart';

class FormBuilderFieldOption<T> extends StatelessWidget {
  final Widget? child;
  final T value;

  /// Creates an option for fields with selection options
  const FormBuilderFieldOption({
    Key? key,
    required this.value,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child ?? Text(value.toString());
  }
}

/// Field to select one value from a list of Radio Widgets
class FormBuilderRadioGroup<T> extends FormBuilderField<T> {
  final Axis wrapDirection;
  final bool shouldRadioRequestFocus;
  final Color? activeColor;
  final Color? focusColor;
  final Color? hoverColor;
  final ControlAffinity controlAffinity;
  final double wrapRunSpacing;
  final double wrapSpacing;
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
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    FocusNode? focusNode,
    FormFieldSetter<T>? onSaved,
    // FormFieldValidator<T>? validator,
    InputDecoration decoration = const InputDecoration(),
    Key? key,
    required this.options,
    T? initialValue,
    this.shouldRadioRequestFocus = false,
    this.activeColor,
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
    this.wrapSpacing = 0.0,
    this.wrapTextDirection,
    this.wrapVerticalDirection = VerticalDirection.down,
    ValueChanged<T?>? onChanged,
    ValueTransformer<T?>? valueTransformer,
    VoidCallback? onReset,
  }) : super(
          key: key,
          initialValue: initialValue,
          name: 'name',
          validator: (value) {
            return null;
          },
          valueTransformer: valueTransformer,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          onSaved: onSaved,
          enabled: enabled,
          onReset: onReset,
          focusNode: focusNode,
          decoration: decoration,
          builder: (FormFieldState<T?> field) {
            final state = field as _FormBuilderRadioGroupState<T>;

            return GroupedRadio<T>(
              activeColor: activeColor,
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
              wrapSpacing: wrapSpacing,
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
