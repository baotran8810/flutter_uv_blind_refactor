import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final SpeakingService _speakingService;
  final SemanticsManageController _semanticsManageController;

  AppRouteObserver({
    required SpeakingService speakingService,
    required SemanticsManageController semanticsManageController,
  })  : _speakingService = speakingService,
        _semanticsManageController = semanticsManageController;

  void _onNavigateTo(PageRoute<dynamic> route) {
    _speakingService.pauseCommonPlayer();
    _speakingService.pauseAllPlayers();

    _focusSemanticsToPageTitle(route);
  }

  void _onNavigateBack({
    required PageRoute<dynamic> route,
    required PageRoute<dynamic> previousRoute,
  }) {
    _speakingService.pauseCommonPlayer();
    _speakingService.pauseAllPlayers();

    _focusSemanticsToPageTitle(previousRoute);
  }

  // Make title page the first focus of a11y
  void _focusSemanticsToPageTitle(PageRoute<dynamic> route) {
    final currentRoute = route.settings.name;
    if (currentRoute != null) {
      final semanticsIdOfRouteTitle = getSemanticsIdOfPageTitle(currentRoute);
      _semanticsManageController.focus(semanticsIdOfRouteTitle);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _onNavigateTo(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _onNavigateTo(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _onNavigateBack(route: route, previousRoute: previousRoute);
    }
  }
}
