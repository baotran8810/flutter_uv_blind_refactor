import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/string_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/setting_controller/setting_controller.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics_controller_impl.dart';
import 'package:get/get.dart';

part 'widgets/app_semantics_custom.dart';
part 'widgets/app_semantics_default.dart';

class AppSemantics extends AppGetView<AppSemanticsController> {
  final String? semanticId;
  final Widget child;
  final List<String> labelList;
  final String? langKey;
  final Function? onAccessibilityFocus;
  final bool isFocused;
  final bool isButton;
  final bool isSlider;
  final bool isTextField;
  final bool? toggleValue;
  final bool isDocSemantic;
  final AppVoice? appVoiceReadingPage;

  final SettingController _settingController;
  final SemanticsManageController _semanticsManageController;

  AppSemantics({
    Key? key,
    this.semanticId,
    required this.child,
    required this.labelList,
    this.langKey,
    this.onAccessibilityFocus,
    this.isFocused = false,
    this.isButton = false,
    this.isSlider = false,
    this.isTextField = false,
    this.toggleValue,
    this.isDocSemantic = false,
    this.appVoiceReadingPage,
  })  : _settingController = Get.find(),
        _semanticsManageController = Get.find(),
        super(
          key: key,
          initialController: AppSemanticsControllerImpl(
            readingService: Get.find(),
            appSettingDao: Get.find(),
            semanticsManageController: Get.find(),
            semanticId: semanticId,
          ),
        );

  @override
  Widget build(BuildContext context, AppSemanticsController controller) {
    return Obx(
      () {
        final String? semanticsIdToFocus =
            _semanticsManageController.semanticsIdToFocus;
        final String semanticsId = controller.semanticsId;

        final bool shouldExclude =
            semanticsIdToFocus != null && semanticsIdToFocus != semanticsId;

        return ExcludeSemantics(
          excluding: shouldExclude,
          child: _buildSemantics(semanticsId, controller),
        );
      },
    );
  }

  Widget _buildSemantics(
    String semanticsId,
    AppSemanticsController controller,
  ) {
    return Obx(
      () {
        final appSetting = _settingController.appSetting;

        late bool isUseCustomSemantics;

        final isInReadingPage = isDocSemantic;
        if (isInReadingPage) {
          isUseCustomSemantics = appVoiceReadingPage == AppVoice.univoice;
        } else {
          isUseCustomSemantics = appSetting?.appVoice == AppVoice.univoice;
        }

        if (!isUseCustomSemantics) {
          // Default semantics
          return _AppSemanticsDefault(
            labelList: labelList,
            isFocused: isFocused,
            isButton: isButton,
            isSlider: isSlider,
            isTextField: isTextField,
            toggleValue: toggleValue,
            onDismiss: _getDissmissFunc(),
            onDidGainAccessibilityFocus: () async {
              _didGainAccessibilityFocus(semanticsId);
            },
            onDidLoseAccessibilityFocus: () {
              _didLoseAccessibilityFocus(controller);
            },
            child: child,
          );
        }
        // Custom semantics. Override VoiceOver/Talkback by using our speaking.
        return _AppSemanticsCustom(
          labelList: labelList,
          langKey: langKey,
          isFocused: isFocused,
          isButton: isButton,
          isSlider: isSlider,
          isTextField: isTextField,
          toggleValue: toggleValue,
          isDocSemantic: isDocSemantic,
          controller: controller,
          onDismiss: _getDissmissFunc(),
          onDidGainAccessibilityFocus: () async {
            _didGainAccessibilityFocus(semanticsId);
          },
          onDidLoseAccessibilityFocus: () {
            _didLoseAccessibilityFocus(controller);
          },
          child: child,
        );
      },
    );
  }

  void Function()? _getDissmissFunc() {
    return Platform.isIOS
        ? () {
            Get.back();
          }
        : null;
  }

  void _didGainAccessibilityFocus(String semanticsId) {
    _semanticsManageController.defocus();
    _semanticsManageController.setIsFocusing(semanticsId);

    if (onAccessibilityFocus != null) {
      onAccessibilityFocus!.call();
    }
  }

  void _didLoseAccessibilityFocus(AppSemanticsController controller) {
    controller.stopSpeaking();
  }
}
