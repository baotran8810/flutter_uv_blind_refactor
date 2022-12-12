import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';

class LoadingViewUtils {
  /// show loading and return the dialog
  static Future<void> showLoading({String message = 'Please wait...'}) async {
    // EasyLoading.instance
    //   ..backgroundColor = ThemeColorUtils.getOnSecondary(Get.overlayContext!)
    //   ..textColor = ThemeColorUtils.getSecondary(Get.overlayContext!);

    await EasyLoading.show(
      status: tra(LocaleKeys.semTxt_loading),
      maskType: EasyLoadingMaskType.black,
    );
  }

  static Future<void> hideLoading() async {
    await EasyLoading.dismiss();
  }
}
