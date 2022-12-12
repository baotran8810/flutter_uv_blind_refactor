import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';

class AppButton extends StatelessWidget {
  final Color? color;
  final Widget child;
  final String? semanticText;
  final Function onClick;
  final double? borderRadius;
  final double? height;
  final bool square;

  const AppButton({
    this.color,
    required this.child,
    required this.onClick,
    this.semanticText,
    this.borderRadius,
    this.height,
    this.square = false,
  });

  @override
  Widget build(BuildContext context) {
    if (semanticText == null) {
      return _buildChild();
    }

    return AppSemantics(
      labelList: [semanticText!],
      isButton: true,
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    return InkWell(
      onTap: () => onClick(),
      child: Container(
        height: height ?? 46,
        width: square ? height : null,
        decoration: BoxDecoration(
          color: color ?? AppColors.royalBlue,
          borderRadius: BorderRadius.circular(borderRadius ?? 2.0),
        ),
        child: child,
      ),
    );
  }
}
