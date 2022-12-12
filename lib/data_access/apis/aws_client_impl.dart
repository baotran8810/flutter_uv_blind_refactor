import 'dart:convert';
import 'dart:typed_data';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_uv_blind_refactor/common/config/environments.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/aws_client.dart';
import 'package:http/http.dart';
import 'package:sigv4/sigv4.dart';

class AwsClientImpl implements AwsClient {
  late CognitoCredentials _credentials;

  AwsClientImpl() {
    // _initCredentials();
  }

  Future<void> _initCredentials() async {
    _credentials = CognitoCredentials(
      appEnvData.awsIdentityPoolId,
      CognitoUserPool(
        "${appEnvData.awsRegion}_something",
        "",
      ),
    );

    try {
      await _credentials.getGuestAwsCredentialsId();
    } catch (e, st) {
      LogUtils.d('Cannot get AWS Credential', e, st);
    }
  }

  bool _hasCredential() {
    return _credentials.accessKeyId != null &&
        _credentials.secretAccessKey != null;
  }

  @override
  Future<Uint8List> getPollyFile({
    required String sentence,
    required String langKey,
    required Gender gender,
  }) async {
    if (_hasCredential() == false) {
      // Try to init credentials again for the next time
      _initCredentials();
      throw Exception('Credential has not been init');
    }

    final voiceId = _getVoiceId(langKey, gender);
    if (voiceId == null) {
      throw Exception('CUSTOM: Language $langKey does not support on Polly');
    }

    final endpoint =
        "https://polly.${appEnvData.awsRegion}.amazonaws.com/v1/speech";

    final client = Sigv4Client(
      keyId: _credentials.accessKeyId!,
      accessKey: _credentials.secretAccessKey!,
      sessionToken: _credentials.sessionToken,
      region: appEnvData.awsRegion,
      serviceName: 'polly',
    );

    final request = client.request(
      endpoint,
      method: 'POST',
      body: jsonEncode(
        {
          "OutputFormat": "mp3",
          "VoiceId": voiceId,
          "Text": sentence,
          "TextType": "text",
          "LexiconNames": ["DicP1", "DicP2", "DicP3", "DicP4", "DicP5"]
        },
      ),
      signPayload: false,
    );

    final response = await post(
      request.url,
      headers: request.headers,
      body: request.body,
    );

    return response.bodyBytes;
  }

  String? _getVoiceId(String langKey, Gender gender) {
    if (gender == Gender.male) {
      // Male
      if (langKey == ".jpn") {
        return "Takumi";
      }
      if (langKey == ".eng") {
        return "Joey";
      }
      if (langKey == ".chi") {
        return "Zhiyu";
      }
      if (langKey == ".zho") {
        return "Zhiyu";
      }
      if (langKey == ".kor") {
        return "Seoyeon";
      }
      if (langKey == ".fre") {
        return "Lea";
      }
      if (langKey == ".ger") {
        return "Hans";
      }
      if (langKey == ".spa") {
        return "Enrique";
      }
      if (langKey == ".ita") {
        return "Giorgio";
      }
      if (langKey == ".por") {
        return "Ricardo";
      }
      if (langKey == ".rus") {
        return "Maxim";
      }
      if (langKey == ".ara") {
        return "Zeina";
      }
      if (langKey == ".dut") {
        return "Ruben";
      }
      if (langKey == ".hin") {
        return "Aditi";
      }
    } else {
      // Female
      if (langKey == ".jpn") {
        return "Mizuki";
      }
      if (langKey == ".eng") {
        return "Joanna";
      }
      if (langKey == ".chi") {
        return "Zhiyu";
      }
      if (langKey == ".zho") {
        return "Zhiyu";
      }
      if (langKey == ".kor") {
        return "Seoyeon";
      }
      if (langKey == ".fre") {
        return "Celine";
      }
      if (langKey == ".ger") {
        return "Marlene";
      }
      if (langKey == ".spa") {
        return "Conchita";
      }
      if (langKey == ".ita") {
        return "Carla";
      }
      if (langKey == ".por") {
        return "Tatyana";
      }
      if (langKey == ".rus") {
        return "Tatyana";
      }
      if (langKey == ".ara") {
        return "Zeina";
      }
      if (langKey == ".dut") {
        return "Lotte";
      }
      if (langKey == ".hin") {
        return "Aditi";
      }
    }
  }
}
