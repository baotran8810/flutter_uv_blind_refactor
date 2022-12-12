import 'package:dio/dio.dart';
import 'package:flutter_uv_blind_refactor/common/config/environments.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/aws_client.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/aws_client_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/rest_client.dart';

void _setupRestClient() {
  final dio = Dio();
  dio.options = BaseOptions(
    headers: <String, dynamic>{
      // 'ApiKey': appConstants.apiKey,
    },
  );

  // if ([null, ''].contains(bearerAuthToken) == false) {
  //   dio.options.headers["Authorization"] = "Bearer $bearerAuthToken";
  // }

  putPermanent<RestClient>(RestClient(
    dio,
    baseUrl: appEnvData.baseRestApiUrl,
  ));
}

void setupApiClients() {
  _setupRestClient();
  putPermanent<AwsClient>(AwsClientImpl());
}
