import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/prefecture/prefecture_select_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/ward/ward_select_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_detail_page/facility_point_detail_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_main_page/facility_main_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/file_list_page/file_list_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/language_setting_page/language_setting_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/menu_page/menu_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/mixed_code_list_page/mixed_code_list_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_compass_page/navi_compass_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_direction_page/navi_direction_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_menu_page/navi_menu_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/notification_detail_page/notification_detail_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/notification_list_page/notification_list_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/onboard_permission_page/onboard_address_collect_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/onboard_permission_page/onboard_permission_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/reading_page/reading_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/scan_page/scan_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/setting_page/setting_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/setting_scan_page/setting_scan_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/splash_page/splash_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/term_of_service/term_of_service_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/tutorial_pages/images/tutorial_images_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/tutorial_pages/tutorial_onboarding_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/tutorial_pages/tutorial_text_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/voice_input_page/voice_input_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/voice_input_result_page/voice_input_result_page.dart';
import 'package:get/get.dart';

part './build_route_utils.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const mixedCodeList = '/mixed-code-list';
  static const naviMenu = '/navi-menu';
  static const naviCompass = '/navi-compass';
  static const naviDirection = '/navi-direction';
  static const facilityMain = '/facility-main';
  static const facilityPointDetail = '/facility-point-detail';
  static const termOfService = '/tos';
  static const onboardPermission = '/onboard-permission';
  static const scan = "/scan";
  static const reading = '/reading';
  static const menu = '/menu';
  static const settingScan = '/settingScan';
  static const setting = "/setting";
  static const tutorialText = '/tutorial-text';
  static const tutorialImages = '/tutorial-images';
  static const tutorialTextOnboard = '/tutorial-text-onboard';
  static const tutorialAddressOnboard = '/tutorial-address-onboard';
  static const prefectureSelect = '/prefecture-select';
  static const wardSelect = '/ward-select';
  static const notifications = '/notifications';
  static const notificationDetail = '/notifications/detail';
  static const languageSetting = '/settings/language';
  static const fileList = "/fileList";
  static const voiceInput = '/voice-input';
  static const voiceInputResult = '/voice-input/result';

  static final List<_AppPage> _pages = [
    _AppPage(
      name: AppRoutes.splash,
      page: (settings) => SplashPage(),
    ),
    _AppPage(
      name: AppRoutes.mixedCodeList,
      page: (settings) => MixedCodeListPage(
        arguments: settings.arguments! as MixedCodeListPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.naviMenu,
      page: (settings) => NaviMenuPage(
        arguments: settings.arguments! as NaviMenuPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.naviCompass,
      page: (settings) => NaviCompassPage(
        arguments: settings.arguments! as NaviCompassPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.naviDirection,
      page: (settings) => NaviDirectionPage(
        arguments: settings.arguments! as NaviDirectionPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.facilityMain,
      page: (settings) => FacilityMainPage(
        arguments: settings.arguments! as FacilityMainPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.facilityPointDetail,
      page: (settings) => FacilityPointDetailPage(
        arguments: settings.arguments! as FacilityPointDetailPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.termOfService,
      page: (settings) => TermOfServicePage(),
    ),
    _AppPage(
      name: AppRoutes.onboardPermission,
      page: (settings) => OnboardPermissionPage(),
    ),
    _AppPage(
      name: AppRoutes.scan,
      page: (settings) => ScanPage(
        notificationsController: Get.find(),
      ),
    ),
    _AppPage(
      name: AppRoutes.menu,
      page: (settings) => MenuPage(
        appInfoController: Get.find(),
        notificationsController: Get.find(),
      ),
    ),
    _AppPage(
      name: AppRoutes.tutorialText,
      page: (settings) => TutorialTextPage(),
    ),
    _AppPage(
      name: AppRoutes.tutorialImages,
      page: (settings) => TutorialImagesPage(),
    ),
    _AppPage(
      name: AppRoutes.tutorialTextOnboard,
      page: (settings) => TutorialOnboardingPage(),
    ),
    _AppPage(
      name: AppRoutes.reading,
      page: (settings) => ReadingPage(
        arguments: settings.arguments! as ReadingPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.settingScan,
      page: (settings) => SettingScanPage(),
    ),
    _AppPage(
      name: AppRoutes.setting,
      page: (settings) => SettingPage(),
    ),
    _AppPage(
      name: AppRoutes.notifications,
      page: (settings) => NotificationListPage(
        notificationsController: Get.find(),
      ),
    ),
    _AppPage(
      name: AppRoutes.notificationDetail,
      page: (settings) => NotificationDetailPage(
        arguments: settings.arguments! as NotificationDetailPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.tutorialAddressOnboard,
      page: (settings) => OnboardAddressCollectPage(),
    ),
    _AppPage(
      name: AppRoutes.prefectureSelect,
      page: (settings) => PrefectureSelectPage(
        arguments: settings.arguments! as PrefectureSelectPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.wardSelect,
      page: (settings) => WardSelectPage(
        arguments: settings.arguments! as WardSelectPageArguments,
      ),
    ),
    _AppPage(
      name: AppRoutes.languageSetting,
      page: (settings) => LanguageSettingPage(),
    ),
    _AppPage(
      name: AppRoutes.fileList,
      page: (settings) => FileListPage(),
    ),
    _AppPage(
      name: AppRoutes.voiceInput,
      page: (settings) => VoiceInputPage(),
    ),
    _AppPage(
      name: AppRoutes.voiceInputResult,
      page: (settings) => VoiceInputResultPage(
        arguments: settings.arguments! as VoiceInputResultPageArguments,
      ),
    ),
  ];

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final myRouteBuilder = AppRoutes._pages.firstWhereOrNull(
      (page) => page.name == settings.name,
    );
    if (myRouteBuilder != null) {
      return _buildPageRoute(
        child: myRouteBuilder.page(settings),
        settings: settings,
      );
    }

    return _buildPageRoute(
      child: Scaffold(
        body: Center(
          child: Text('No route found: ${settings.name}.'),
        ),
      ),
    );
  }
}

class _AppPage {
  final String name;
  final Widget Function(RouteSettings) page;

  const _AppPage({
    required this.name,
    required this.page,
  });
}
