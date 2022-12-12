import 'package:flutter_uv_blind_refactor/common/utility/miscs/debouncer.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_setting_dao/app_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics_controller.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

final Debouncer _debouncer = Debouncer(milliseconds: 400);

class AppSemanticsControllerImpl extends GetxController
    implements AppSemanticsController {
  final SpeakingService _readingService;
  final AppSettingDao _appSettingDao;
  final SemanticsManageController _semanticsManageController;

  final String? semanticId;

  AppSemanticsControllerImpl({
    required SpeakingService readingService,
    required AppSettingDao appSettingDao,
    required SemanticsManageController semanticsManageController,
    required this.semanticId,
  })  : _readingService = readingService,
        _appSettingDao = appSettingDao,
        _semanticsManageController = semanticsManageController;

  final Rx<String> _semanticsId = Rx('UNASSIGNED');
  @override
  String get semanticsId => _semanticsId.value;

  @override
  void onInit() {
    super.onInit();

    _semanticsId.value = semanticId ?? Uuid().v4();
    _semanticsManageController.addSemanticsId(semanticsId);
  }

  @override
  void onClose() {
    _semanticsManageController.removeSemanticsId(semanticsId);

    super.onClose();
  }

  @override
  Future<void> speak(
    List<String> labelList, {
    required String? langKey,
    required bool isDocSemantic,
  }) async {
    _readingService.cancelSpeaking();

    _debouncer.run(() async {
      final appSetting = await _appSettingDao.getAppSetting();

      await _readingService.speakSentences(
        labelList
            .map((label) => SpeakItem(text: label, langKey: langKey))
            .toList(),
        speed: appSetting.audioReadingSpeed,
        applyPitch: isDocSemantic,
      );
    });
  }

  @override
  Future<void> stopSpeaking() async {
    await Future.wait([
      _readingService.pauseCommonPlayer(),
      _readingService.pauseAllPlayers(),
    ]);
  }
}
