abstract class HardwareService {
  Future<void> vibrate({
    Duration duration = const Duration(milliseconds: 500),
  });

  Future<void> enableWakelock();
  Future<void> disableWakelock();
}
