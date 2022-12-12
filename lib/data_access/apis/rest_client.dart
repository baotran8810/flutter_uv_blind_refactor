import 'package:dio/dio.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/like_notification_request_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/like_notification_response_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_like_count_response_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_request_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_response_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/unlike_notification_response_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/online_scan_code/online_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/speech/get_speech_request_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/speech/get_speech_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  // - Notifications

  @POST('api/hub/push-history')
  Future<NotificationResponseDto> getNotifications(
    @Body() NotificationRequestDto request,
  );

  @POST('api/message-statistic')
  Future<LikeNotificationResponseDto> likeNotification(
    @Body() LikeNotificationRequestDto request,
  );

  @DELETE('api/message-statistic/{id}')
  Future<UnlikeNotificationResponseDto> unlikeNotification(
    @Path('id') String likeId,
  );

  @GET('api/message-statistic/count')
  Future<NotificationLikeCountResponseDto> getLikeCount(
    @Query('where') String whereQuery,
  );

  @POST('api/hub/decode-code')
  Future<String> decodeCode(
    @Query('link') String linkQuery,
  );

  // - Address
  @GET('statics/all-cites-wards.json')
  Future<List<AddressDto>> getAddressList();

  // - Polly
  @POST('api/sound/get-speech-stream')
  Future<GetSpeechResponseDto> getSpeech(
    @Body() GetSpeechRequestDto request,
  );

  // - Get online content
  @GET('api/codes/{id}')
  Future<GetOnlineDocScanCodeResponseDto> getDocOnlineContent(
    @Path('id') String codeID,
  );

  // * Example

  // @GET('stock/search/company/{fragment}')
  // Future<List<CompanySummaryDto>> searchCompanies(
  //   @Path('fragment') String fragment, {
  //   @Query('limit') int limit = 10,
  // });

  // @POST('stock/quote')
  // Future<Map<String, StockQuoteDto>> getQuotes(
  //   @Body() GetQuotesRequestDto request,
  // );
}
