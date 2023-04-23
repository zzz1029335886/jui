import 'package:flutter/material.dart';

import 'jui_form_base.dart';
import 'radio_group/form_builder_checkbox_group.dart';
import 'radio_group/form_builder_field.dart';
import 'radio_group/form_builder_field_option.dart';

typedef JUIFormCheckboxGroupOption<T> = FormBuilderFieldOption<T>;

// ignore: must_be_immutable
class JUIFormCheckboxGroup<T> extends JUIFormBase {
  final List<JUIFormCheckboxGroupOption<T>> options;
  final List<T>? initialValue;
  final ValueChanged<List<T>?>? onChanged;
  final Color? activeColor;
  final Axis wrapDirection;

  JUIFormCheckboxGroup(
      {required this.options,
      this.initialValue,
      this.onChanged,
      this.activeColor,
      this.wrapDirection = Axis.horizontal,
      super.key,
      super.config,
      super.style,
      super.styleBuilder});

  @override
  JUIFormBaseState<JUIFormCheckboxGroup> createState() =>
      _JUIFormRadioGroupState<T>();
}

class _JUIFormRadioGroupState<T>
    extends JUIFormBaseState<JUIFormCheckboxGroup<T>> {
  @override
  Widget contentBuild(BuildContext context) {
    return Flexible(
      child: FormBuilderCheckboxGroup<T>(
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        activeColor: const Color.fromRGBO(129, 216, 208, 1),
        options: widget.options,
        orientation: OptionsOrientation.wrap,
        wrapVerticalDirection: VerticalDirection.down,
        controlAffinity: ControlAffinity.leading,
        wrapDirection: widget.wrapDirection,
      ),
    );
  }

  @override
  MainAxisAlignment? get mainAxisAlignment => MainAxisAlignment.spaceBetween;
}
