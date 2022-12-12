import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/location_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/rest_client.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/address_setting_dao/address_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/notifications_info_dao/notifications_info_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/like_notification_request_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/like_notification_response_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_app_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_request_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_response_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notifications_info_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/notification_repository/notification_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final RestClient _restClient;
  final NotificationsInfoDao _notificationsInfoDao;
  final AddressSettingDao _addressSettingDao;

  NotificationRepositoryImpl({
    required RestClient restClient,
    required NotificationsInfoDao notificationsInfoDao,
    required AddressSettingDao addressSettingDao,
  })  : _restClient = restClient,
        _notificationsInfoDao = notificationsInfoDao,
        _addressSettingDao = addressSettingDao;

  @override
  Future<List<NotificationAppDto>?> getNotificationList({
    required int skip,
    required int limit,
  }) async {
    final addressTagData = _addressSettingDao.getCurrentAddress();
    if (addressTagData == null) {
      LogUtils.iNoST('Abort getNotificationList because tagData is null.');
    }

    final notificationsInfo =
        await _notificationsInfoDao.getNotificationsInfo();

    final dateFrom = notificationsInfo.dateDeleted;

    NotificationResponseDto? response;

    try {
      response = await _restClient.getNotifications(
        NotificationRequestDto(
          limit: limit,
          skip: skip,
          filter: NotifRequestFilterDto(
            target: "univoice_blind",
            prefecture: addressTagData != null
                ? int.parse(addressTagData.prefecture)
                : null,
            city: addressTagData?.city,
            ward: addressTagData?.ward,
            gender: null,
            age: null,
            from: dateFrom,
          ),
        ),
      );
    } on DioError catch (e) {
      final isNoConnectionError = e.error is SocketException;
      if (!isNoConnectionError) {
        LogUtils.e(e.message, e);
      }
    }

    // TODO make a better error handling system
    if (response == null) {
      return null;
    }

    if (response.status != 'OK') {
      return null;
    }

    // Apply notificationsInfo into rawNotificationList from API
    // by populating `hasRead` & `hasLiked`

    final List<NotificationAppDto> notificationList = response.data
        // Convert to appDto
        .map((rawNotification) =>
            NotificationAppDto.fromRawDto(rawDto: rawNotification))
        // Filter out deleted items
        .where((notification) => !notificationsInfo.notificationIdListDeleted
            .contains(notification.id))
        .toList();

    for (final freshNotification in notificationList) {
      // Apply hasRead & hasLiked (MUTATE)
      freshNotification.applyNotificationsInfo(notificationsInfo);
    }

    return notificationList;
  }

  @override
  Future<NotificationsInfoDto> getNotificationsInfo() async {
    return await _notificationsInfoDao.getNotificationsInfo();
  }

  @override
  Future<void> deleteAllNotifications() async {
    await _notificationsInfoDao.setDateDeletedNow();
  }

  @override
  Future<void> readAllNotifications() async {
    await _notificationsInfoDao.setDateReadNow();
  }

  @override
  Future<void> deleteNotification(int id) async {
    await _notificationsInfoDao.addNotificationIdToDelete(id);
  }

  @override
  Future<void> readNotification(int id) async {
    await _notificationsInfoDao.addNotificationIdToRead(id);
  }

  @override
  Future<void> likeNotification({
    required int id,
    required String? userId,
    required void Function() logEventHandler,
  }) async {
    final Position position = await LocationUtils.getCurrentPosition();

    final addressTagData = _addressSettingDao.getCurrentAddress();
    if (addressTagData == null) {
      LogUtils.e('Unexpected: tagData cannot be null');
    }

    final LikeNotificationResponseDto likeResponse =
        await _restClient.likeNotification(LikeNotificationRequestDto(
      userId: userId,
      notificationId: id,
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      countryCode: Get.locale?.countryCode,
      prefecture: addressTagData?.prefecture,
      city: addressTagData?.city,
      ward: addressTagData?.ward,
    ));

    await _notificationsInfoDao.addNotificationIdToLiked(
      notificationId: id,
      likeId: likeResponse.data.id,
    );

    logEventHandler();
  }

  @override
  Future<void> unlikeNotification(int id) async {
    final NotificationsInfoDto notifInfos =
        await _notificationsInfoDao.getNotificationsInfo();

    final String? foundLikeId = notifInfos.notificationIdWithLikeId[id];

    if (foundLikeId == null) {
      return;
    }

    await _restClient.unlikeNotification(foundLikeId);
    await _notificationsInfoDao.removeNotificationIdFromLiked(
      notificationId: id,
    );
  }

  @override
  Future<int> getNotificationLikeCount(int id) async {
    final response = await _restClient.getLikeCount('{"message_id": $id}');
    return response.data.count;
  }
}
