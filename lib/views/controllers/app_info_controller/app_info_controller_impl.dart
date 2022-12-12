import 'package:flutter_uv_blind_refactor/views/controllers/app_info_controller/app_info_controller.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoControllerImpl implements AppInfoController {
  final Rx<String?> _versionName = Rx(null);
  @override
  String? get versionName => _versionName.value;

  @override
  Future<void> init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _versionName.value = packageInfo.version;
  }
}
