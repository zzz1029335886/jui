import 'package:flutter/material.dart';

import 'jui_form_base.dart';
import 'radio_group/form_builder_field.dart';
import 'radio_group/form_builder_radio_group.dart';

typedef JUIFormRadioGroupOption<T> = FormBuilderFieldOption<T>;

// ignore: must_be_immutable
class JUIFormRadioGroup<T> extends JUIFormBase {
  final List<JUIFormRadioGroupOption<T>> options;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final Color? activeColor;
  final Axis wrapDirection;

  JUIFormRadioGroup(
      {required this.options,
      this.initialValue,
      this.onChanged,
      this.activeColor,
      this.wrapDirection = Axis.horizontal,
      super.key,
      super.config,
      super.configBuilder,
      super.parentConfigBuilder});

  @override
  JUIFormBaseState<JUIFormRadioGroup> createState() =>
      _JUIFormRadioGroupState<T>();
}

class _JUIFormRadioGroupState<T>
    extends JUIFormBaseState<JUIFormRadioGroup<T>> {
  @override
  Widget contentBuild(BuildContext context) {
    return Flexible(
      child: FormBuilderRadioGroup<T>(
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
