import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';

class StringViewUtils {
  static List<String> getScriptsTappable() {
    return [
      ConstScript.kSilence,
      tra(LocaleKeys.semTxt_doubleTapToActivate),
    ];
  }

  static List<String> getScriptsEditable() {
    return [
      ConstScript.kSilence,
      tra(LocaleKeys.semTxt_doubleTapToEdit),
    ];
  }

  //TODO config semantic for slider
  static String getScriptSlider() {
    return tra(LocaleKeys.semTxt_slider);
  }

  static String getOnOffStatus(bool isOn) {
    return isOn ? 'On' : 'Off';
  }
}
