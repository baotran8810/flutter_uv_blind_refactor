import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';

enum AppButtonNewType {
  solid,
  outlined,
}

class AppButtonNew extends StatelessWidget {
  final void Function()? onPressed;
  final String? semanticId;
  final String? semanticLabel;
  final List<String> suffixLabelList;
  final double height;
  final Color? btnColor;
  final Color? textColor;
  final Widget child;
  final AppButtonNewType type;
  final BorderRadius? borderRadius;
  final void Function()? onAccessibilityFocus;
  final bool readSemanticBtn;

  const AppButtonNew({
    Key? key,
    this.semanticId,
    this.semanticLabel,
    this.suffixLabelList = const [],
    this.onPressed,
    this.height = 40,
    this.btnColor,
    this.textColor,
    required this.child,
    this.type = AppButtonNewType.solid,
    this.borderRadius,
    this.onAccessibilityFocus,
    this.readSemanticBtn = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: height,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final primaryColor = btnColor ?? AppColors.burgundyRed;
    final onPrimaryColor = textColor ?? Colors.white;

    return AppSemantics(
      semanticId: semanticId,
      labelList: [
        if (semanticLabel != null) semanticLabel!,
        ...suffixLabelList,
      ],
      isButton: readSemanticBtn,
      onAccessibilityFocus: onAccessibilityFocus,
      child: type == AppButtonNewType.solid
          // ignore: deprecated_member_use
          ? FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: onPressed,
              color: primaryColor,
              textColor: onPrimaryColor,
              disabledColor: Theme.of(context).disabledColor,
              disabledTextColor: onPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(5),
              ),
              child: child,
            )
          // ignore: deprecated_member_use
          : OutlineButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: onPressed,
              color: primaryColor,
              borderSide: BorderSide(
                width: 2,
                color: primaryColor,
              ),
              textColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(5),
              ),
              child: child,
            ),
    );
  }
}
