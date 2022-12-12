import 'package:flutter_uv_blind_refactor/common/utility/utils.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/app_info_controller/app_info_controller.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/app_info_controller/app_info_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/notifications_controller/notifications_controller.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/notifications_controller/notifications_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/setting_controller/setting_controller.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/setting_controller/setting_controller_impl.dart';
import 'package:get/get.dart';

void setupControllers() {
  putPermanent<AppInfoController>(
    AppInfoControllerImpl(),
  );
  putPermanent<NotificationsController>(
    NotificationsControllerImpl(
      notificationRepository: Get.find(),
    ),
  );
  putPermanent<SemanticsManageController>(
    SemanticsManageControllerImpl(),
  );
  putPermanent<SettingController>(
    SettingControllerImpl(
      addressRepository: Get.find(),
      appSettingRepository: Get.find(),
    ),
  );
}
