import 'package:flutter/material.dart';

class AppColors {
  static const Color screenBg = Color(0xFFFFFFFF);
  static const Color headerBorderColor = Color(0xFFBFBFBF);
  static const Color itemBorderColor = Color(0xFFDEDEDE);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color royalBlue = Color(0xFF00689D);
  static const Color burgundyRed = Color(0xFFA21942);
  static const Color darkGreen = Color(0xFF3F7E44);
  static const Color orange = Color(0xFFFD6925);
  static const Color darkMustard = Color(0xFFBF8B2E);
  static const Color blue02 = Color(0xFF19486A);
  static const Color magenta = Color(0xFFDD1367);
  static const Color gray = Color(0xFFD9D9D9);
  static const Color gray02 = Color(0xFF2D2C2C);

  static const Color lightGreen = Color(0xFF4C9F38);
  static const Color goldenYellow = Color(0xFFFD9D24);

  static const Color gray03 = Color(0xFFA5A5A5);
  static const Color pink = Color(0xFFFFA8C2);

  // Text
  static const Color textBlack = Color(0xFF212121);

  /// Scan setting - border color
  ///
  /// Order matters!
  static const List<Color> scanBorderColorList = [
    Colors.white,
    Colors.black,
    Color(0xffC5192D),
    Color(0xff00689D),
  ];

  /// Scan setting - border color - Old App
  ///
  /// Order must match with [scanBorderColorList]
  static const List<List<double>> oldScanBorderColorList = [
    [1, 1, 1],
    [0, 0, 0],
    [0.501960814, 0, 0],
    [0, 0, 1],
    [0.250980407, 0.501960814, 0],
    [0.7843137255, 0.2862745098, 0.2156862745],
    [0.250980407, 0, 0.501960814],
    [0.5, 0, 0.5],
  ];
}
