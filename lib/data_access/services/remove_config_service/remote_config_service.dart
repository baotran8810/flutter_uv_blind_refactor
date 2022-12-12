abstract class RemoteConfigService {
  Future<void> init();
  DateTime? getPollyLastModifiedAt();
}
