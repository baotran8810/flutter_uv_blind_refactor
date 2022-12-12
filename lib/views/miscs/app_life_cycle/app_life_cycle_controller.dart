import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class AppLifeCycleController extends GetxController
    with WidgetsBindingObserver {
  AppLifeCycleController();

  @override
  @mustCallSuper
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  @mustCallSuper
  void onClose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.onClose();
  }

  void onAppPause() {}
  void onAppResume() {}
  void onAccessibilityChange() {}

  // App Life circle
  var _lastAppState = AppLifecycleState.resumed; // record Paused, Resume state
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        _lastAppState = state;
        onAppPause();
        break;
      case AppLifecycleState.resumed:
        // to deal with case Resumed => Resumed by notification pull down behavior
        if (state != _lastAppState) {
          onAppResume();
        }
        _lastAppState = state;
        break;
      default:
        break;
    }
  }

  @override
  Future<void> didChangeAccessibilityFeatures() async {
    onAccessibilityChange();
  }

  // Future<bool> _isSleepTooLong() async {
  //   final timestamp = await _getTimestamp();
  //   // Resume state by Notification confirm dialog for the first time
  //   if (timestamp == null) {
  //     return false;
  //   }
  //   final before = DateTime.fromMillisecondsSinceEpoch(timestamp);
  //   final now = DateTime.now();
  //   final timeDifference = now.difference(before);
  //   return timeDifference.inSeconds > appConstants.sleepTooLongInSeconds;
  // }

  // Future<int?> _getTimestamp() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt(appConstants.timestampKey);
  // }

  // Future<void> _setTimestamp(int timestamp) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt(appConstants.timestampKey, timestamp);
  // }

  // @override
  // Future<bool> didPushRoute(String route) async {
  //   await onPushRoute(route);
  //   return true;
  // }

  // @override
  // Future<bool> didPopRoute() async {
  //   onPopRoute();
  //   return true;
  // }
}
