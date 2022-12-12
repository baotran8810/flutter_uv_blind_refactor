import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/setting_controller/setting_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:get/get.dart';

class AppSwitcher extends StatelessWidget {
  final String? semanticId;
  final String semanticsLabel;
  final bool currentValue;
  final void Function(bool newValue) onChanged;

  final SpeakingService _speakingService;
  final SettingController _settingController;

  AppSwitcher({
    Key? key,
    this.semanticId,
    required this.semanticsLabel,
    required this.currentValue,
    required this.onChanged,
  })  : _speakingService = Get.find(),
        _settingController = Get.find(),
        super(key: key);

  /// Only speak in 2 cases:
  /// - 1: If blind mode && use custom semantics (polly)
  /// - 2: If blind mode && use default semantics && on Android (workaround)
  Future<void> _speakValueOnChanged(bool newValue) async {
    final bool useCustomSemantics =
        _settingController.appSetting?.appVoice == AppVoice.univoice;

    final bool isBlindModeOn = await A11yUtils.isBlindModeOn();

    if (isBlindModeOn && useCustomSemantics) {
      await _speakingService.speakSentences(
        [
          SpeakItem(
            text: tra(
              LocaleKeys.semTxt_settingValueWA,
              namedArgs: {
                "value": newValue ? "On" : "Off",
              },
            ),
          ),
        ],
      );
    }
    // Workaround because Android cannot speak CupertinoSwitch properly
    else if (isBlindModeOn && !useCustomSemantics && Platform.isAndroid) {
      A11yUtils.speak(newValue ? 'On' : 'Off');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSemantics(
      semanticId: semanticId,
      labelList: [semanticsLabel],
      toggleValue: currentValue,
      child: CupertinoSwitch(
        activeColor: AppColors.burgundyRed,
        trackColor: AppColors.gray03,
        value: currentValue,
        onChanged: (bool value) {
          onChanged(value);

          _speakValueOnChanged(value);
        },
      ),
    );
  }
}
