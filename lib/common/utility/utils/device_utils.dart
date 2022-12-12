import 'dart:io';

import 'package:get/get.dart';

abstract class DeviceUtils {
  static bool _isScreenSizeEqual(double value) {
    return Get.width == value || Get.height == value;
  }

  static bool isIphoneXOrNewer() {
    if (!Platform.isIOS) {
      return false;
    }

    return
        // X, XS, 11pro, 12mini, 13mini
        _isScreenSizeEqual(812) ||
            // 12, 12Pro, 13, 13Pro
            _isScreenSizeEqual(844) ||
            // XSMax, XR, 11, 11ProMax
            _isScreenSizeEqual(896) ||
            // 12ProMax, 13ProMax
            _isScreenSizeEqual(926);
  }
}
