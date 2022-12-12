import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_life_cycle/app_life_cycle_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_listview/app_listview_controller.dart';
import 'package:get/get.dart';

class AppListViewControllerImpl extends AppLifeCycleController
    implements AppListViewController {
  final Rx<bool> _isBlindModeOn = Rx(false);
  @override
  bool get isBlindModeOn => _isBlindModeOn.value;

  @override
  Future<void> onInit() async {
    super.onInit();

    _checkBlindMode();
  }

  @override
  void onAccessibilityChange() {
    _checkBlindMode();
  }

  Future<void> _checkBlindMode() async {
    _isBlindModeOn.value = await A11yUtils.isBlindModeOn();
  }
}
