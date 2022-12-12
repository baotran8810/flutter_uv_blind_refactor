import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_uv_decoder/flutter_camera_uv_decoder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_uv_blind_refactor/common/theme/app_theme.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/setup_api_clients.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/setup_hive.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_sqlite/setup_sqlite.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/setup_repositories.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/deeplink_service/deeplink_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/setup_services.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/setup_controllers.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_route_observer/app_route_observer.dart';
import 'package:get/get.dart';

late List<CameraDescription> cameras;
late final RouteObserver<PageRoute<dynamic>> appRouteObserver;

Future<void> mainDelegate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();

  // Order of setting up must be from bottom to top layer
  await Future.wait([
    setupHive(),
    setupSqlite(),
  ]);
  setupApiClients();
  setupRepositories();
  setupServices();
  setupControllers();

  cameras = await availableCameras();
  appRouteObserver = AppRouteObserver(
    speakingService: Get.find(),
    semanticsManageController: Get.find(),
  );
  await Get.find<DeeplinkService>().init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => EasyLocalization(
        supportedLocales: [
          ...SupportedLanguage.values
              .map((supLang) => supLang.getLocale())
              .toList(),
        ],
        saveLocale: false,
        path: AppTranslationsAssets.translationsFolder,
        // startLocale: SupportedLanguage.ja.getLocale(),
        fallbackLocale: SupportedLanguage.ja.getLocale(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: appThemeData,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        final Widget child1 = EasyLoading.init()(context, child);
        final Widget child2 = DevicePreview.appBuilder(context, child1);

        return child2;
      },
      navigatorObservers: [appRouteObserver],
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}
