import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/voice_input_service/voice_input_service.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/voice_input_result_page/voice_input_result_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/voice_input_result_page/voice_input_result_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/scan_code_list_view.dart';
import 'package:get/get.dart';

class VoiceInputResultPageArguments {
  final VoiceDecodedResult result;

  VoiceInputResultPageArguments({
    required this.result,
  });
}

class VoiceInputResultPage extends AppGetView<VoiceInputResultPageController> {
  final VoiceInputResultPageArguments arguments;

  VoiceInputResultPage({
    Key? key,
    required this.arguments,
  }) : super(
          key: key,
          initialController: VoiceInputResultPageControllerImpl(
            scanCodeRepository: Get.find(),
            speakingService: Get.find(),
            languageSettingRepository: Get.find(),
            voiceDecodedResult: arguments.result,
          ),
        );

  @override
  Widget build(
    BuildContext context,
    VoiceInputResultPageController controller,
  ) {
    return BaseLayout(
      header: AppHeader(
        titleText: () {
          switch (arguments.result.action) {
            case VoiceAction.listing:
              return tra(LocaleKeys.titlePage_voiceInputResultList);
            case VoiceAction.reading:
              return tra(LocaleKeys.titlePage_voiceInputResultRead);
          }
        }(),
      ),
      body: Obx(
        () {
          final scanCodeList = controller.scanCodeList;
          final resultText = controller.craftSearchResultOutput();

          return Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingNormal,
                    vertical: AppDimens.paddingNormal,
                  ),
                  child: AppSemantics(
                    labelList: [resultText],
                    child: Text(
                      resultText,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: () {
                  switch (arguments.result.action) {
                    case VoiceAction.listing:
                      return _ResultListingView(
                        scanCodeList: scanCodeList,
                      );
                    case VoiceAction.reading:
                      return _ResultReadingView(
                        scanCodeList: scanCodeList,
                        onPressedReadNext: () {
                          controller.readNextFile();
                        },
                      );
                  }
                }(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ResultListingView extends StatelessWidget {
  final List<ScanCodeDto> scanCodeList;

  const _ResultListingView({
    Key? key,
    required this.scanCodeList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScanCodeListView(
      scanCodeList: scanCodeList,
    );
  }
}

class _ResultReadingView extends StatelessWidget {
  final List<ScanCodeDto> scanCodeList;
  final Function() onPressedReadNext;

  const _ResultReadingView({
    Key? key,
    required this.scanCodeList,
    required this.onPressedReadNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = tra(LocaleKeys.btn_readNextFile);
    return AppSemantics(
      labelList: [text],
      isButton: true,
      child: Material(
        child: InkWell(
          onTap: onPressedReadNext,
          child: Ink(
            color: Color(0xFFA21942),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
