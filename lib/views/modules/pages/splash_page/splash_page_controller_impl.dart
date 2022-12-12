import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/onboard_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_data_repository/app_data_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/data_migration_service/data_migration_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/remove_config_service/remote_config_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/splash_page/splash_page_controller.dart';
import 'package:get/get.dart';

class SplashPageControllerImpl extends GetxController
    implements SplashPageController {
  final AppDataRepository _appDataRepository;
  final RemoteConfigService _remoteConfigService;
  final DataMigrationService _dataMigrationService;
  final SpeakingService _speakingService;

  SplashPageControllerImpl({
    required AppDataRepository appDataRepository,
    required DataMigrationService dataMigrationService,
    required RemoteConfigService remoteConfigService,
    required SpeakingService speakingService,
  })  : _appDataRepository = appDataRepository,
        _remoteConfigService = remoteConfigService,
        _dataMigrationService = dataMigrationService,
        _speakingService = speakingService;

  @override
  Future<void> onInit() async {
    super.onInit();

    await _remoteConfigService.init();

    await _speakingService.configAudioSession();
    await _clearPollyCacheIfNeeded();

    final appData = await _appDataRepository.getAppData();

    final bool? hasMigrated = appData.hasMigratedFromOldApp;
    final bool isOnboardCompleted = appData.isOnboardCompleted;

    if (hasMigrated != true) {
      _dataMigrationService.startMigrate();
    }

    if (isOnboardCompleted == false) {
      Get.offAllNamed(AppRoutes.termOfService);
      return;
    }

    OnboardViewUtils.navigateAfterOnboard();
  }

  Future<void> _clearPollyCacheIfNeeded() async {
    // await _speakingService.clearCachedPollyFiles();
    // return;

    final remotePollyLastModifiedAt =
        _remoteConfigService.getPollyLastModifiedAt();

    if (remotePollyLastModifiedAt == null) {
      return;
    }

    final appData = await _appDataRepository.getAppData();
    final cachedPollyLastModifiedAt = appData.pollyLastModifiedAt;

    if (remotePollyLastModifiedAt.compareTo(cachedPollyLastModifiedAt) <= 0) {
      return;
    }

    await Future.wait([
      _appDataRepository.saveData(
        pollyLastModifiedAt: remotePollyLastModifiedAt,
      ),
      _speakingService.clearCachedPollyFiles(),
    ]);

    LogUtils.iNoST(
      'New polly updated at ${remotePollyLastModifiedAt.toIso8601String()}. Cleared polly cache.',
    );
  }
}
