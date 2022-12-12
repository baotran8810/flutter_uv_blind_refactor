import 'package:flutter/material.dart';

abstract class NaviMenuPageController {
  TextEditingController get textController;

  bool get isBookmark;
  Future<void> setBookmark();
  Future<void> deleteCode();

  Future<void> openGuidance();
  void openDirections();
  Future<void> toggleRevert();
  Future<void> openMap();
  void openSettings();
}
