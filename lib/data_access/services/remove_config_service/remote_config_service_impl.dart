import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/remove_config_service/remote_config_service.dart';

class RemoteConfigServiceImpl implements RemoteConfigService {
  late final RemoteConfig remoteConfig;

  @override
  Future<void> init() async {
    remoteConfig = RemoteConfig.instance;

    await remoteConfig.ensureInitialized();

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 5),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await remoteConfig.setDefaults({
      _pollyLastPodifiedAtKey: '',
    });

    try {
      await remoteConfig.fetchAndActivate();

      LogUtils.iNoST('Successfully initialized RemoteConfig');
    } catch (e) {
      LogUtils.e('Failed to fetch RemoteConfig', e);
    }
  }

  @override
  DateTime? getPollyLastModifiedAt() {
    final lastModifiedAtStr = remoteConfig.getString(_pollyLastPodifiedAtKey);
    if (lastModifiedAtStr.isEmpty) {
      return null;
    }

    return DateTime.tryParse(lastModifiedAtStr);
  }
}

/// ISOString | ''
const String _pollyLastPodifiedAtKey = 'pollyLastModifiedAt';
