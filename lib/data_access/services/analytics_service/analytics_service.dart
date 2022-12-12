// ignore_for_file: constant_identifier_names
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/code_info_dto.dart';

abstract class AnalyticsService {
  Future<void> setPushStatusProperty(PushStatus pushStatus);

  Future<void> logPushAction({
    required PushAction action,
    required String title,
    required int messageId,
    required String? companyName,
  });
  Future<void> logLikePush({
    required String title,
    required int messageId,
    required String? companyName,
  });
  Future<void> logOpenPush({
    required String title,
    required int messageId,
    required String? companyName,
  });
  Future<void> logOpenFile({
    required String codeName,
    required CodeInfoDto? codeInfo,
  });
  Future<void> logNaviActionFromNavi({
    required NaviAction action,
    required String codeName,
    required CodeInfoDto? codeInfo,
  });
  Future<void> logNaviActionFromSpot({
    required NaviAction action,
    required String pointName,
    required CodeInfoDto? codeInfo,
  });
  Future<void> logDecodeScanCode({
    required DecodeSource decodeSource,
    required String codeName,
    required CodeInfoDto? codeInfo,
  });
  Future<void> logPollyCount({
    required int textLength,
    required String langKey,
  });
}

enum PushStatus {
  success,
  fail,
  notAllowed,
}

enum PushAction {
  received,
  liked,
  openedUnread,
}

enum NaviAction {
  start,
  stop,
}

enum DecodeSource {
  scanning,
  attachedCode,
}
