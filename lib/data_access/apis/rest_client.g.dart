// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<NotificationResponseDto> getNotifications(request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NotificationResponseDto>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'api/hub/push-history',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NotificationResponseDto.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LikeNotificationResponseDto> likeNotification(request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LikeNotificationResponseDto>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'api/message-statistic',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LikeNotificationResponseDto.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UnlikeNotificationResponseDto> unlikeNotification(likeId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UnlikeNotificationResponseDto>(
            Options(method: 'DELETE', headers: _headers, extra: _extra)
                .compose(_dio.options, 'api/message-statistic/$likeId',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UnlikeNotificationResponseDto.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NotificationLikeCountResponseDto> getLikeCount(whereQuery) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'where': whereQuery};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NotificationLikeCountResponseDto>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'api/message-statistic/count',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NotificationLikeCountResponseDto.fromJson(_result.data!);
    return value;
  }

  @override
  Future<String> decodeCode(linkQuery) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'link': linkQuery};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, 'api/hub/decode-code',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<List<AddressDto>> getAddressList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<AddressDto>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'statics/all-cites-wards.json',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => AddressDto.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<GetSpeechResponseDto> getSpeech(request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetSpeechResponseDto>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'api/sound/get-speech-stream',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetSpeechResponseDto.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetOnlineDocScanCodeResponseDto> getDocOnlineContent(codeID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetOnlineDocScanCodeResponseDto>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'api/codes/$codeID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetOnlineDocScanCodeResponseDto.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
