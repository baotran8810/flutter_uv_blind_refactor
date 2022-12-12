import 'package:flutter/material.dart';

class AppInkwell extends StatelessWidget {
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;
  final double elevation;
  final Color? shadowColor;
  final Widget? child;

  const AppInkwell({
    Key? key,
    this.onPressed,
    this.padding,
    this.borderRadius,
    this.decoration,
    this.width,
    this.height,
    this.elevation = 0,
    this.shadowColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      elevation: elevation,
      shadowColor: shadowColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        child: Ink(
          padding: padding,
          decoration: decoration?.copyWith(borderRadius: borderRadius),
          width: width,
          height: height,
          child: child,
        ),
      ),
    );
  }
}
