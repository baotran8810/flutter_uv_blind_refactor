import 'package:flutter/material.dart';

class MicroVolume extends StatefulWidget {
  /// [0, 1]
  final double volume;
  final Widget child;
  final double endRadius;
  final BoxShape shape;
  final Duration duration;
  final Color glowColor;

  const MicroVolume({
    Key? key,
    required this.volume,
    required this.child,
    required this.endRadius,
    this.shape = BoxShape.circle,
    this.duration = const Duration(milliseconds: 2000),
    this.glowColor = Colors.white,
  }) : super(key: key);

  @override
  _MicroVolumeState createState() => _MicroVolumeState();
}

class _MicroVolumeState extends State<MicroVolume>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      shape: widget.shape,
      color: widget.glowColor.withOpacity(0.3),
    );

    return Container(
      height: widget.endRadius * 2,
      width: widget.endRadius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform.scale(
            scale: widget.volume,
            child: Container(
              height: widget.endRadius * 2,
              width: widget.endRadius * 2,
              decoration: decoration,
            ),
          ),
          Transform.scale(
            scale: widget.volume,
            child: Container(
              height: (widget.endRadius * 2) * (3 / 4),
              width: (widget.endRadius * 2) * (3 / 4),
              decoration: decoration,
            ),
          ),
          widget.child,
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
