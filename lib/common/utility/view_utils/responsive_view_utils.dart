import 'package:get/get.dart';

abstract class ResponsiveViewUtils {
  static bool isTablet() {
    return Get.width > 700;
  }
}
