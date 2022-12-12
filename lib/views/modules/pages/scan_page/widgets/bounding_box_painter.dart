import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/scan_page/scan_page_controller.dart';

class BoundingBoxPainter extends CustomPainter {
  UVRect? boundingBox;
  int stroke;
  int color;
  Size cameraPreviewSize;

  BoundingBoxPainter({
    required this.boundingBox,
    required this.color,
    required this.stroke,
    required this.cameraPreviewSize,
  });

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    if (boundingBox == null) return;

    final paint = Paint()
      ..color = AppColors.scanBorderColorList[color]
      ..strokeWidth = (stroke + 1) * 5
      ..strokeCap = StrokeCap.round;

    final Size previewSize = cameraPreviewSize;
    final double previewSizeHeight = previewSize.height;
    final double previewSizeWidth = previewSize.width;

    final double pHeight = size.height;
    final double pWidth = size.width;

    final unwrapEdge = boundingBox!;
    if (unwrapEdge.tlX == null) return;

    final Offset tl = Offset(
      pWidth - (unwrapEdge.tlY! * pHeight / previewSizeWidth),
      unwrapEdge.tlX! * pWidth / previewSizeHeight,
    );
    final Offset tr = Offset(
      pWidth - (unwrapEdge.trY! * pHeight / previewSizeWidth),
      unwrapEdge.trX! * pWidth / previewSizeHeight,
    );
    final Offset br = Offset(
      pWidth - (unwrapEdge.brY! * pHeight / previewSizeWidth),
      unwrapEdge.brX! * pWidth / previewSizeHeight,
    );
    final Offset bl = Offset(
      pWidth - (unwrapEdge.blY! * pHeight / previewSizeWidth),
      unwrapEdge.blX! * pWidth / previewSizeHeight,
    );

    canvas.drawLine(tl, tr, paint);
    canvas.drawLine(tr, br, paint);
    canvas.drawLine(br, bl, paint);
    canvas.drawLine(bl, tl, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
