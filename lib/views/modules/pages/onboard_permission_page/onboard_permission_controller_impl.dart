import 'dart:io';

import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/onboard_permission_page/onboard_permission_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardPermissionControllerImpl extends GetxController
    implements OnboardPermissionController {
  OnboardPermissionControllerImpl();

  @override
  Future<void> requestPermissions() async {
    await Permission.location.request();

    if (Platform.isIOS) {
      await Permission.notification.request();
      await A11yUtils.requestSiriPermission();
    }
  }
}
