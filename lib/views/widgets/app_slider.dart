import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';

class AppSlider extends StatelessWidget {
  final String semanticsLabel;
  final double min;
  final double max;
  final double currentValue;
  final void Function(double newValue) onChanged;

  const AppSlider({
    Key? key,
    required this.semanticsLabel,
    required this.min,
    required this.max,
    required this.currentValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO use app semantics here

    return Slider(
      activeColor: AppColors.burgundyRed,
      min: min,
      max: max,
      label: semanticsLabel,
      value: currentValue,
      onChanged: onChanged,
    );
  }
}
