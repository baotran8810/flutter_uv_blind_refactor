import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/linkify_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_data_dao/app_data_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/language_setting_dao/language_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_data/app_data_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/sign_language_url/sign_language_service.dart';
import 'package:http/http.dart' as http;

class SignLanguageServiceImpl implements SignLanguageService {
  final AppDataDao _appDataDao;
  final LanguageSettingDao _languageSettingDao;

  SignLanguageServiceImpl({
    required AppDataDao appDataDao,
    required LanguageSettingDao languageSettingDao,
  })  : _appDataDao = appDataDao,
        _languageSettingDao = languageSettingDao;

  @override
  Future<String?> getSignLanguageUrl(String codeHeader) async {
    // * 1: Get appKey
    final AppDataDto _appDataDto = await _appDataDao.getAppData();

    final signLanguageId = _appDataDto.signLanguageId;
    final String appKey = _extractAppKey(signLanguageId);

    // * 2: Get new codeHeader

    final String? langKey = await _languageSettingDao.getCurrentLangKey();

    final String? newCodeHeader = _extractCodeHeader(
      codeHeader: codeHeader,
      langKey: langKey,
    );

    if (newCodeHeader == null) {
      return null;
    }

    // * 3: Use appKey & newCodeHeader to fetch signLangUrl from Server

    final url = Uri.parse(
      'http://translationsystem.uni-voice.jp/service?ids=$newCodeHeader&appkey=$appKey',
    );
    try {
      final response = await http.get(url);
      return LinkifyViewUtils.getURL(response.body);
    } on Exception catch (_) {
      //
    }
  }

  /// codeHeader sent from native example 18.5.jpn.1.1 but ids just "18.5.{languageSetting}"
  String? _extractCodeHeader({
    required String codeHeader,
    required String? langKey,
  }) {
    final List<String> codeHeaderInfos = codeHeader.split(".");

    try {
      // Get "18.1"
      String newCodeHeader = "${codeHeaderInfos[0]}.${codeHeaderInfos[1]}";

      // Add language code to ids
      if (langKey != null) {
        newCodeHeader += langKey;
      } else {
        newCodeHeader += codeHeaderInfos[2];
      }

      return newCodeHeader;
    } catch (e) {
      return null;
    }
  }

  String _extractAppKey(String signLanguageId) {
    final dateNowJP = DateTime.now().toUtc().add(Duration(hours: 9));

    final plainText =
        '$signLanguageId ${DateFormat('yyyyMMddHHmmss').format(dateNowJP)}';
    final key = Key.fromUtf8('ounisvoiceotranslationlsymstiems');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.ecb,
    ));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    final appKey = Uri.encodeComponent(base64Url.encode(encrypted.bytes));

    return appKey;
  }
}
