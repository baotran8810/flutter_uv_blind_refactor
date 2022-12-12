import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

abstract class A11yUtils {
  static const _talkbackMethodChannel =
      MethodChannel("SKG.univoice.dev/talkback");

  static Future<bool> isBlindModeOn() async {
    return await _talkbackMethodChannel.invokeMethod("checkTalkBack") as bool;
  }

  static void speak(String text) {
    SemanticsService.announce(text, TextDirection.ltr);
  }

  /// On iOS, if we double tap a button, it will speak the label again,
  /// so to prevent that, we'll need this workaround.
  static Future<void> cancelSpeak() async {
    if (Platform.isIOS) {
      await Future.delayed(Duration(milliseconds: 100));

      speak('--');
    }
  }

  // Temp
  static Future<bool> requestSiriPermission() async {
    return await _talkbackMethodChannel.invokeMethod('requestSiriPermission')
        as bool;
  }
}
