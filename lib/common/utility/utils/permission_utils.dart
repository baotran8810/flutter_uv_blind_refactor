import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<void> checkLocation() async {
    if (await Permission.location.isPermanentlyDenied) {
      if (Platform.isIOS) {
        final isConfirmed = await DialogViewUtils.showConfirmDialog(
          messageText: tra(LocaleKeys.txt_locationDiaLogMessage),
          titleText: tra(LocaleKeys.txt_confirm),
          textYes: tra(LocaleKeys.btn_setting),
          textNo: tra(LocaleKeys.btn_later),
        );
        if (!isConfirmed) {
          Get.back();
        } else {
          await AppSettings.openAppSettings();
        }
      }
    }
  }
}
