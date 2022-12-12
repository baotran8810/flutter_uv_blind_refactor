import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/code_info_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';

class _Event {
  static const receivePush = 'receive_push';
  static const likePush = 'like_push';
  static const openPush = 'open_push';
  static const openFile = 'open_file';
  static const startNavi = 'start_navigate';
  static const stopNavi = 'stop_navigate';
  static const scanCode = 'scan_code';
  static const openAttachedCode = 'decode_attachedcode';
  static const pollyCount = 'polly_count';
}

class _PropValue {
  static const success = 'success';
  static const fail = 'fail';
  static const notAllowed = 'not_allowed';
}

class AnalyticsServiceImpl implements AnalyticsService {
  static const analyticsMC = MethodChannel('uv_analytics');
  final _firebaseAnalytics = FirebaseAnalytics();

  @override
  Future<void> setPushStatusProperty(PushStatus pushStatus) async {
    final String propertyValue;
    switch (pushStatus) {
      case PushStatus.success:
        propertyValue = _PropValue.success;
        break;
      case PushStatus.fail:
        propertyValue = _PropValue.fail;
        break;
      case PushStatus.notAllowed:
        propertyValue = _PropValue.notAllowed;
        break;
    }

    await _firebaseAnalytics.setUserProperty(
      name: 'push_status',
      value: propertyValue,
    );
  }

  Future<void> _logEvent({
    required String eventName,
    required Map<String, String?> parameters,
  }) async {
    // Remove null parameters to pass FirebaseAnalytics' warnings
    final Map<String, String?> cleanedParameters = Map.from(parameters);
    cleanedParameters.removeWhere((key, value) => value == null);

    await _firebaseAnalytics.logEvent(
      name: eventName,
      parameters: cleanedParameters,
    );
  }

  @override
  Future<void> logPushAction({
    required PushAction action,
    required String title,
    required int messageId,
    required String? companyName,
  }) async {
    final String eventName;
    switch (action) {
      case PushAction.received:
        eventName = _Event.receivePush;
        break;
      case PushAction.liked:
        eventName = _Event.likePush;
        break;
      case PushAction.openedUnread:
        eventName = _Event.openPush;
    }

    await _logEvent(
      eventName: eventName,
      parameters: {
        'push_title': title,
        'push_message_id': messageId.toString(),
        'push_sender': companyName,
      },
    );
  }

  @override
  Future<void> logLikePush({
    required String title,
    required int messageId,
    required String? companyName,
  }) async {
    await _logEvent(
      eventName: _Event.likePush,
      parameters: {
        'push_title': title,
        'push_message_id': messageId.toString(),
        'push_sender': companyName,
      },
    );
  }

  @override
  Future<void> logOpenPush({
    required String title,
    required int messageId,
    required String? companyName,
  }) async {
    await _logEvent(
      eventName: _Event.openPush,
      parameters: {
        'push_title': title,
        'push_message_id': messageId.toString(),
        'push_sender': companyName,
      },
    );
  }

  @override
  Future<void> logOpenFile({
    required String codeName,
    required CodeInfoDto? codeInfo,
  }) async {
    await _logEvent(
      eventName: _Event.openFile,
      parameters: {
        'code_name': codeName,
        'code_id': codeInfo?.codeId,
        'company_id': codeInfo?.companyId,
        'project_id': codeInfo?.projectId,
      },
    );
  }

  @override
  Future<void> logNaviActionFromNavi({
    required NaviAction action,
    required String codeName,
    required CodeInfoDto? codeInfo,
  }) async {
    final String eventName;
    switch (action) {
      case NaviAction.start:
        eventName = _Event.startNavi;
        break;
      case NaviAction.stop:
        eventName = _Event.stopNavi;
        break;
    }

    await _logEvent(
      eventName: eventName,
      parameters: {
        'route_name': codeName,
        'code_id': codeInfo?.codeId,
        'company_id': codeInfo?.companyId,
        'project_id': codeInfo?.projectId,
      },
    );
  }

  @override
  Future<void> logNaviActionFromSpot({
    required NaviAction action,
    required String pointName,
    required CodeInfoDto? codeInfo,
  }) async {
    final String eventName;
    switch (action) {
      case NaviAction.start:
        eventName = _Event.startNavi;
        break;
      case NaviAction.stop:
        eventName = _Event.stopNavi;
        break;
    }

    await _logEvent(
      eventName: eventName,
      parameters: {
        'destination_name': pointName,
        'code_id': codeInfo?.codeId,
        'company_id': codeInfo?.companyId,
        'project_id': codeInfo?.projectId,
      },
    );
  }

  @override
  Future<void> logDecodeScanCode({
    required DecodeSource decodeSource,
    required String codeName,
    required CodeInfoDto? codeInfo,
  }) async {
    final String eventName;
    switch (decodeSource) {
      case DecodeSource.scanning:
        eventName = _Event.scanCode;
        break;
      case DecodeSource.attachedCode:
        eventName = _Event.openAttachedCode;
        break;
    }

    await _logEvent(
      eventName: eventName,
      parameters: {
        'code_name': codeName,
        'code_id': codeInfo?.codeId,
        'company_id': codeInfo?.companyId,
        'project_id': codeInfo?.projectId,
      },
    );
  }

  @override
  Future<void> logPollyCount({
    required int textLength,
    required String langKey,
  }) async {
    await _logEvent(
      eventName: _Event.pollyCount,
      parameters: {
        'text_length': textLength.toString(),
        'lang': langKey,
      },
    );
  }
}
