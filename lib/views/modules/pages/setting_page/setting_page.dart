import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/setting_controller/setting_controller.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/prefecture/prefecture_select_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/setting_page/setting_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/setting_page/setting_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_dropdown.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_slider.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_switcher.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';

class SettingPage extends AppGetView<SettingPageController> {
  final SettingController _settingController;

  SettingPage({Key? key})
      : _settingController = Get.find(),
        super(
          key: key,
          initialController: SettingPageControllerImpl(),
        );

  @override
  Widget build(BuildContext context, controller) {
    return BaseLayout(
      hasSafeAreaBody: false,
      header: _buildHeader(),
      body: _buildBody(context, controller),
    );
  }

  Widget _buildHeader() {
    return AppHeader(
      titleText: tra(LocaleKeys.titlePage_setting),
      semanticsTitle: tra(LocaleKeys.semTitlePage_setting),
      helpScript: tra(LocaleKeys.helpScript_setting),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SettingPageController controller,
  ) {
    return Obx(
      () {
        final appSetting = _settingController.appSetting;

        if (appSetting == null) {
          return SizedBox();
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // ---- General settings
              _buildBooleanSettingItem(
                semLabel: tra(LocaleKeys.semTxt_settingContinuousScan),
                title: tra(LocaleKeys.txt_settingContinuousScan),
                currentValue: appSetting.continuousScan,
                onChanged: (bool value) {
                  _settingController.setContinuousScan(value);
                },
              ),
              _buildBooleanSettingItem(
                semLabel: tra(LocaleKeys.semTxt_settingCameraLight),
                title: tra(LocaleKeys.txt_settingCameraLight),
                currentValue: appSetting.flashlight,
                onChanged: (bool value) {
                  _settingController.setFlashLight(value);
                },
              ),
              _buildBooleanSettingItem(
                semLabel: tra(LocaleKeys.semTxt_settingSignLanguage),
                title: tra(LocaleKeys.txt_settingSignLanguage),
                currentValue: appSetting.signLanguage,
                onChanged: (bool value) {
                  _settingController.setSignLanguage(value);
                },
              ),
              _buildBooleanSettingItem(
                semLabel: tra(LocaleKeys.semTxt_settingNoSound),
                title: tra(LocaleKeys.txt_settingNoSound),
                currentValue: appSetting.soundApp,
                onChanged: (bool value) {
                  _settingController.setSoundApp(value);
                },
              ),
              _buildAddressSelect(
                title: tra(LocaleKeys.txt_settingAddress),
                currentAddress: _settingController.currentAddress,
                reloadAddress: _settingController.reloadAddress,
              ),
              // ---- Voice settings
              _buildSectionHeader(
                tra(LocaleKeys.txt_voiceSettings),
              ),
              _buildDropdownSettingItem<AppVoice>(
                semLabel: tra(LocaleKeys.semTxt_settingAppVoice),
                title: tra(LocaleKeys.txt_settingAppVoice),
                valueList: AppVoice.values,
                getDisplayText: (value) {
                  switch (value) {
                    case AppVoice.device:
                      return tra(LocaleKeys.txt_appVoiceDevice);
                    case AppVoice.univoice:
                      return tra(LocaleKeys.txt_appVoiceUnivoice);
                  }
                },
                currentValue: appSetting.appVoice,
                onChanged: (newValue) {
                  _settingController.setAppVoice(
                    newValue ?? appSetting.appVoice,
                  );
                },
              ),
              _buildDropdownSettingItem<Gender>(
                semLabel: tra(LocaleKeys.semTxt_settingVoiceGender),
                title: tra(LocaleKeys.txt_settingVoiceGender),
                valueList: Gender.values,
                getDisplayText: (value) {
                  switch (value) {
                    case Gender.male:
                      return tra(LocaleKeys.txt_appMale);
                    case Gender.female:
                      return tra(LocaleKeys.txt_appFemale);
                  }
                },
                currentValue: appSetting.readingGender,
                onChanged: (newValue) {
                  _settingController.setReadingGender(
                    newValue ?? appSetting.readingGender,
                  );
                },
              ),
              _buildSlider(
                semLabel: tra(LocaleKeys.semTxt_settingReadingSpeed),
                title: tra(LocaleKeys.txt_settingReadingSpeed),
                onChange: (double value) {
                  _settingController.setAudioReadingSpeed(value);
                },
                min: SpeakingSpeedRange.kMin,
                max: SpeakingSpeedRange.kMax,
                value: appSetting.audioReadingSpeed,
              ),
              _buildSlider(
                semLabel: tra(LocaleKeys.semTxt_settingVoicePitch),
                title: tra(LocaleKeys.txt_settingVoicePitch),
                onChange: (double value) {
                  _settingController.setVoicePitch(value);
                },
                min: SpeakingPitchRange.kMin,
                max: SpeakingPitchRange.kMax,
                value: appSetting.voicePitch,
              ),
              // ---- Navi settings
              _buildSectionHeader(
                tra(LocaleKeys.txt_naviSettings),
              ),
              _buildDropdownSettingItem<int>(
                semLabel: tra(LocaleKeys.semTxt_settingNaviGpsRadius),
                title: tra(LocaleKeys.txt_settingGpsRadius),
                valueList: kRadiusGpsSettingList,
                getDisplayText: (value) => '${value}m',
                currentValue: appSetting.radiusGPS,
                onChanged: (newValue) {
                  _settingController.setRadiusGPS(
                    newValue ?? appSetting.radiusGPS,
                  );
                },
              ),
              _buildDropdownSettingItem<int>(
                semLabel: tra(LocaleKeys.semTxt_settingNaviOutOfCourse),
                title: tra(LocaleKeys.txt_settingOutOfCourse),
                valueList: kDistanceOutOfRangeSettingList,
                getDisplayText: (value) => '${value}m',
                currentValue: appSetting.distanceOutOfRange,
                onChanged: (newValue) {
                  _settingController.setDistanceOutOfRange(
                    newValue ?? appSetting.distanceOutOfRange,
                  );
                },
              ),
              _buildBooleanSettingItem(
                semLabel: tra(LocaleKeys.semTxt_settingNaviVoice),
                title: tra(LocaleKeys.txt_settingNaviVoice),
                currentValue: appSetting.voiceGuide,
                onChanged: (bool value) {
                  _settingController.setVoiceGuide(value);
                },
              ),
              _buildBooleanSettingItem(
                semLabel: tra(LocaleKeys.semTxt_settingNaviVibration),
                title: tra(LocaleKeys.txt_settingNaviVibration),
                currentValue: appSetting.vibration,
                onChanged: (bool value) {
                  _settingController.setVibrate(value);
                },
              ),
              _buildBooleanSettingItem(
                semLabel: tra(LocaleKeys.semTxt_settingNaviShake),
                title: tra(LocaleKeys.txt_settingNaviShake),
                currentValue: appSetting.voiceGuidanceWithShake,
                onChanged: (bool value) {
                  _settingController.setVoiceGuidanceWithShake(value);
                },
              ),
              _buildSlider(
                semLabel: tra(LocaleKeys.semTxt_settingNaviVoiceSpeed),
                title: tra(LocaleKeys.txt_settingNaviVoiceSpeed),
                onChange: (double value) {
                  _settingController.setAudioPlayBackSpeed(value);
                },
                min: SpeakingSpeedRange.kMin,
                max: SpeakingSpeedRange.kMax,
                value: appSetting.voiceGuideSpeed,
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlider({
    required String semLabel,
    required String title,
    required double max,
    required double min,
    required double value,
    required void Function(double) onChange,
  }) {
    // Temp to fix slider on Android
    final Widget labelWidget = Text(
      title,
      style: TextStyle(
        fontSize: AppDimens.buttonTextFontSize,
        height: AppDimens.buttonTextLineHeight / AppDimens.buttonTextFontSize,
        fontWeight: FontWeight.w400,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.itemBorderColor,
            width: 1.5,
          ),
        ),
      ),
      height: 58,
      child: Row(
        children: [
          SizedBox(
            width: AppDimens.paddingMedium,
          ),
          Expanded(
            child: ExcludeSemantics(
              child: labelWidget,
            ),
          ),
          AppSlider(
            semanticsLabel: semLabel,
            min: min,
            max: max,
            currentValue: value,
            onChanged: onChange,
          ),
        ],
      ),
    );
  }

  Widget _buildBooleanSettingItem({
    String? semId,
    required String semLabel,
    required String title,
    required bool currentValue,
    required void Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.itemBorderColor,
            width: 1.5,
          ),
        ),
      ),
      child: Container(
        height: 58,
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              width: AppDimens.paddingMedium,
            ),
            Expanded(
              child: ExcludeSemantics(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDimens.buttonTextFontSize,
                    height: AppDimens.buttonTextLineHeight /
                        AppDimens.buttonTextFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            AppSwitcher(
              semanticId: semId,
              semanticsLabel: semLabel,
              currentValue: currentValue,
              onChanged: (newValue) {
                onChanged(newValue);
              },
            ),
            SizedBox(
              width: AppDimens.paddingNormal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSettingItem<T>({
    required String semLabel,
    required String title,
    required T currentValue,
    required List<T> valueList,
    required String Function(T) getDisplayText,
    required void Function(T?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.itemBorderColor,
            width: 1.5,
          ),
        ),
      ),
      child: Container(
        height: 58,
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              width: AppDimens.paddingMedium,
            ),
            Expanded(
              child: ExcludeSemantics(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDimens.buttonTextFontSize,
                    height: AppDimens.buttonTextLineHeight /
                        AppDimens.buttonTextFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            AppDropdown<T>(
              semanticsLabel: semLabel,
              currentValue: currentValue,
              valueList: valueList,
              getDisplayText: getDisplayText,
              onChanged: onChanged,
            ),
            SizedBox(
              width: AppDimens.paddingNormal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSelect({
    required String title,
    required String? currentAddress,
    required Function reloadAddress,
  }) {
    return AppSemantics(
      labelList: [
        title,
        if (currentAddress != null) currentAddress,
      ],
      isButton: true,
      child: InkWell(
        onTap: () async {
          await Get.toNamed(
            AppRoutes.prefectureSelect,
            arguments: PrefectureSelectPageArguments(
              onDone: () {
                Get.close(2);
                reloadAddress();
              },
            ),
          );
        },
        child: Container(
          height: currentAddress != null ? 98 : 58,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: AppDimens.paddingMedium,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: AppDimens.buttonTextFontSize,
                        height: AppDimens.buttonTextLineHeight /
                            AppDimens.buttonTextFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Image.asset(AppAssets.iconChevronRight),
                  SizedBox(
                    width: AppDimens.paddingNormal,
                  ),
                ],
              ),
              if (currentAddress != null)
                SizedBox(
                  height: 8,
                )
              else
                Container(),
              if (currentAddress != null)
                Container(
                  margin: EdgeInsets.only(left: AppDimens.paddingNormal),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.pink,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    currentAddress,
                    style: TextStyle(
                      fontSize: AppDimens.buttonTextFontSize,
                      height: AppDimens.buttonTextLineHeight /
                          AppDimens.buttonTextFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              else
                Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return AppSemantics(
      labelList: [title],
      child: Container(
        height: 56,
        color: AppColors.burgundyRed,
        child: Row(
          children: [
            SizedBox(
              width: AppDimens.paddingMedium,
            ),
            Text(
              title,
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppDimens.headerTextFontSize,
                height: AppDimens.headerTextLineHeight /
                    AppDimens.headerTextFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
