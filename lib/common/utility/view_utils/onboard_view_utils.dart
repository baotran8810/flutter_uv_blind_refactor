import 'package:flutter_uv_blind_refactor/data_access/repositories/address_repository/address_repository.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class OnboardViewUtils {
  static Future<void> navigateAfterOnboard() async {
    // isDenied = didn't ask for permission yet or
    // the permission has been denied before but not permanently
    final bool shouldOpenOnboardPermission =
        await Permission.location.isDenied ||
            await Permission.notification.isDenied;

    if (shouldOpenOnboardPermission &&
        Get.currentRoute != AppRoutes.onboardPermission) {
      Get.toNamed(AppRoutes.onboardPermission);
      return;
    }

    final tagData = Get.find<AddressRepository>().getCurrentAddressTagData();
    final bool hasAddress = tagData != null;
    if (!hasAddress) {
      Get.toNamed(AppRoutes.tutorialAddressOnboard);
      return;
    }

    Get.offAllNamed(AppRoutes.scan);
  }
}
