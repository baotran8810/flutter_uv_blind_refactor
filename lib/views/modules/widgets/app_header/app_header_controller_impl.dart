import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header_controller.dart';
import 'package:get/get.dart';

class AppHeaderControllerImpl extends GetxController
    implements AppHeaderController {
  final SpeakingService _readingService;

  AppHeaderControllerImpl({required SpeakingService readingService})
      : _readingService = readingService;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }

  @override
  Future<void> speak(String label) async {
    A11yUtils.cancelSpeak();

    await _readingService.speakSentences([SpeakItem(text: label)]);
  }
}
