import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/splash_page/splash_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/splash_page/splash_page_controller_impl.dart';
import 'package:get/get.dart';

class SplashPage extends AppGetView<SplashPageController> {
  SplashPage({Key? key})
      : super(
          key: key,
          initialController: SplashPageControllerImpl(
            appDataRepository: Get.find(),
            remoteConfigService: Get.find(),
            dataMigrationService: Get.find(),
            speakingService: Get.find(),
          ),
        );

  @override
  Widget build(BuildContext context, SplashPageController controller) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}
