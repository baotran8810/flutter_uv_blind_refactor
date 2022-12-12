import 'dart:convert' show utf8;

import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/extensions/list_extension.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/regex_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/rest_client.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/code_info_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/facility_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/navi_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/language_setting_repository/language_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/scan_decode_service/scan_decode_service.dart';
import 'package:uuid/uuid.dart';

class _CodeTag {
  final String key;
  final String value;

  const _CodeTag({
    required this.key,
    required this.value,
  });
}

class ScanDecodeServiceImpl implements ScanDecodeService {
  final RestClient _restClient;
  final LanguageSettingRepository _languageSettingRepository;

  ScanDecodeServiceImpl({
    required RestClient restClient,
    required LanguageSettingRepository languageSettingRepository,
  })  : _restClient = restClient,
        _languageSettingRepository = languageSettingRepository;

  @override
  Future<CodeDecodeResult?> decodeFromString(
    String codeStr, {
    String? legacyDocCodeLangKey,
    DateTime? createdDate,
    required void Function(ScanCodeDto)? logEventHandler,
  }) async {
    if (codeStr.trim().isEmpty) {
      return null;
    }

    final cleanedCodeStr = _cleanCodeStr(codeStr);

    final allCodeTagList = _extractCodeTags(cleanedCodeStr);

    final mainCodeTagList = allCodeTagList
        .where((codeTag) => !['%ci', '.%ci'].contains(codeTag.key))
        .toList();

    final subCodeTagList = allCodeTagList
        .where((codeTag) => ['%ci', '.%ci'].contains(codeTag.key))
        .toList();

    final List<ScanCodeDto> scanCodeList;
    final CodeInfoDto? codeInfo = _extractCodeInfo(subCodeTagList);

    if (_isNaviOrFacility(mainCodeTagList)) {
      // Navi/Facility Code
      scanCodeList = _decodeNaviAndFacilityCode(
        mainCodeTagList,
        codeStr: codeStr,
        codeInfo: codeInfo,
        createdDate: createdDate,
      );
    } else if (_isStandardDoc(mainCodeTagList)) {
      // Standard Doc Code
      scanCodeList = [
        await _decodeStandardDocCode(
          mainCodeTagList,
          codeStr: codeStr,
          codeInfo: codeInfo,
          createdDate: createdDate,
        ),
      ];
    } else {
      // Legacy Doc Code
      scanCodeList = [
        _decodeLegacyDocCode(
          cleanedCodeStr,
          codeStr: codeStr,
          codeInfo: codeInfo,
          legacyDocCodeLangKey: legacyDocCodeLangKey,
          createdDate: createdDate,
        ),
      ];
    }

    if (scanCodeList.isEmpty) {
      return null;
    }

    // Analytics
    for (final scanCode in scanCodeList) {
      logEventHandler?.call(scanCode);
    }

    return CodeDecodeResult(
      scanCodeList: scanCodeList,
    );
  }

  @override
  Future<CodeDecodeResult?> decodeFromUrl(
    String url, {
    required void Function(ScanCodeDto)? logEventHandler,
  }) async {
    final response = await _restClient.decodeCode(Uri.encodeFull(url));
    return decodeFromString(response, logEventHandler: logEventHandler);
  }

  // * === Decode stuff in-detail

  String _cleanCodeStr(String codeStr) {
    return codeStr.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  }

  List<_CodeTag> _extractCodeTags(String codeStr) {
    final List<_CodeTag> tagList = [];

    final regex =
        RegExp(r'<tag.*?lang=["|”](.*?)["|”].*?>\s?([\s\S]*?)\s?<\/tag>');

    final matchList = regex.allMatches(codeStr);
    for (final match in matchList) {
      final key = match.group(1);
      final value = match.group(2);
      if (key != null && value != null) {
        tagList.add(_CodeTag(
          key: key,
          value: value,
        ));
      }
    }

    return tagList;
  }

  bool _isNaviOrFacility(List<_CodeTag> codeTagList) {
    return codeTagList.any((codeTag) =>
        codeTag.key == ScanCodeType.navi.getTagKey() ||
        codeTag.key == ScanCodeType.facility.getTagKey());
  }

  bool _isStandardDoc(List<_CodeTag> codeTagList) {
    if (_isNaviOrFacility(codeTagList)) {
      return false;
    }

    return codeTagList.isNotEmpty;
  }

  List<ScanCodeDto> _decodeNaviAndFacilityCode(
    List<_CodeTag> codeTagList, {
    required String codeStr,
    required CodeInfoDto? codeInfo,
    required DateTime? createdDate,
  }) {
    final List<ScanCodeDto> scanCodeList = [];

    for (final codeTag in codeTagList) {
      if (codeTag.key == ScanCodeType.navi.getTagKey()) {
        // Is Navi code
        final naviCode = _decodeNaviCode(
          codeTag.value,
          codeStr: codeStr,
          codeInfo: codeInfo,
          createdDate: createdDate,
        );

        if (naviCode != null) {
          scanCodeList.add(naviCode);
        }
      } else if (codeTag.key == ScanCodeType.facility.getTagKey()) {
        // Is Facility Code
        final facilityCode = _decodeFacilityCode(
          codeTag.value,
          codeStr: codeStr,
          codeInfo: codeInfo,
          createdDate: createdDate,
        );

        if (facilityCode != null) {
          scanCodeList.add(facilityCode);
        }
      }
    }

    return scanCodeList;
  }

  NaviScanCodeDto? _decodeNaviCode(
    String value, {
    required String codeStr,
    required CodeInfoDto? codeInfo,
    required DateTime? createdDate,
  }) {
    try {
      final List<String> values = value.trim().split('\n');
      const String deviceLanguage = "jpn";
      final List<String> languageCode = values[1].split("|");

      // * Set navCourseName
      String navCourseName = '';
      final List<String> courseName = values[2].split("|");
      if (courseName.isNotEmpty) {
        if (courseName.length > 1) {
          int engIndex = -1;
          for (int i = 0; i < languageCode.length; i++) {
            if (languageCode[i].toLowerCase() == "eng") {
              engIndex = i;
            }
            if (deviceLanguage == languageCode[i].toLowerCase()) {
              navCourseName = courseName[i];
              break;
            } else if (i == languageCode.length - 1) {
              if (engIndex >= 0) {
                navCourseName = courseName[engIndex];
              } else {
                navCourseName = courseName[0];
              }
            }
          }
        } else {
          navCourseName = courseName.isEmpty ? "" : courseName[0];
        }
      }

      // * Set navPointList
      final List<PointDto> navPointList = [];
      for (int j = 3; j < values.length; j++) {
        final List<String> info = values[j].split(";");

        // * Set pointName & pointInfo
        String pointName = info[0];
        String? pointInfo;
        final List<String> barrierInfoList = info[5].split("|");
        final List<String> pointNameInfo = info[1].split("|");
        if (pointNameInfo.isEmpty) {
          pointName = "";
        } else {
          if (pointNameInfo.length > 1) {
            int engIndex = -1;
            for (int i = 0; i < languageCode.length; i++) {
              if (languageCode[i].toLowerCase() == "eng") {
                engIndex = i;
              }
              if (deviceLanguage == languageCode[i].toLowerCase()) {
                pointName = pointNameInfo[i];
                if (i < barrierInfoList.length) {
                  pointInfo = barrierInfoList[i];
                }
                break;
              } else if (i == languageCode.length - 1) {
                if (engIndex >= 0) {
                  pointName = pointNameInfo[engIndex];
                  if (engIndex < barrierInfoList.length) {
                    pointInfo = barrierInfoList[engIndex];
                  }
                } else {
                  pointName = pointNameInfo[0];
                  pointInfo = barrierInfoList[0];
                }
              }
            }
          } else {
            pointName = pointNameInfo.isEmpty ? "" : pointNameInfo[0];
            pointInfo = barrierInfoList.isEmpty ? "" : barrierInfoList[0];
          }
        }

        // * Set coordinate
        final StringBuffer builder = StringBuffer();
        builder.write("${info[2]},");
        builder.write(info[3]);
        final String positionInfo = builder.toString();
        final List<String> latLong = positionInfo.split(',');
        final double pointLatitude = double.parse(latLong[0]);
        final double pointLongitude = double.parse(latLong[1]);

        // ** Set beaconId
        final String pointBeaconId = info[4];

        final infoToAdd = PointDto(
          pointName: pointName,
          pointInfo: pointInfo,
          beaconId: pointBeaconId,
          coordinate: CoordinateDto(
            latitude: pointLatitude,
            longitude: pointLongitude,
          ),
          categoryIdStrList: [],
          id: Uuid().v4(),
        );

        navPointList.add(infoToAdd);
      }

      return NaviScanCodeDto(
        courseName: navCourseName,
        pointList: navPointList,
        createdDate: createdDate,
        codeInfo: codeInfo,
        codeStr: codeStr,
      );
    } catch (e, st) {
      LogUtils.e('Failed to parse Navi Code', e, st);
      return null;
    }
  }

  FacilityScanCodeDto? _decodeFacilityCode(
    String value, {
    required String codeStr,
    required CodeInfoDto? codeInfo,
    required DateTime? createdDate,
  }) {
    try {
      final List<String> values = value.trim().split("\n");
      const String deviceLanguage = "jpn";

      final List<String> languageCode = values[1].split("|");

      // * Set facBrochureName
      String facBrochureName = '';
      final List<String> brochurename = values[2].split("|");
      if (brochurename.isEmpty) {
        facBrochureName = "";
      } else {
        if (brochurename.length > 1) {
          int engIndex = -1;
          for (int i = 0; i < languageCode.length; i++) {
            if (languageCode[i].toLowerCase() == "eng") {
              engIndex = i;
            }
            if (deviceLanguage == languageCode[i].toLowerCase()) {
              facBrochureName = brochurename[i];
              break;
            } else if (i == languageCode.length - 1) {
              if (engIndex >= 0) {
                facBrochureName = brochurename[engIndex];
              } else {
                facBrochureName = brochurename[0];
              }
            }
          }
        } else {
          facBrochureName = brochurename[0];
        }
      }

      // * Set facPointList
      final List<PointDto> facPointList = [];
      for (int j = 3; j < values.length; j++) {
        final List<String> info = values[j].trim().split(";");

        // * Set pointInfo
        String? pointInfo;
        if (info.length > 4) {
          final List<String> infoType = info[4].split("|");
          if (infoType.length > 1) {
            int engIndex = -1;
            for (int i = 0; i < languageCode.length; i++) {
              if (languageCode[i].toLowerCase() == "eng") {
                engIndex = i;
              }
              if (deviceLanguage == languageCode[i].toLowerCase()) {
                pointInfo = infoType[i];
                break;
              } else if (i == languageCode.length - 1) {
                if (engIndex >= 0) {
                  pointInfo = infoType[engIndex];
                } else {
                  pointInfo = infoType[0];
                }
              }
            }
          } else {
            pointInfo = infoType.isEmpty ? null : infoType[0];
          }
        }
        if (info[1].contains("\n") || info[2].contains("\n")) {
          continue;
        }

        // * Set pointName
        String pointName = '';
        final List<String> pointNameInfo = info[0].split("|");
        if (pointNameInfo.isEmpty) {
          pointName = "";
        }
        if (pointNameInfo.length > 1) {
          int engIndex = -1;
          for (int i = 0; i < languageCode.length; i++) {
            if (languageCode[i].toLowerCase() == "eng") {
              engIndex = i;
            }
            if (deviceLanguage == languageCode[i].toLowerCase()) {
              pointName = pointNameInfo[i];
              break;
            } else if (i == pointNameInfo.length - 1) {
              if (engIndex >= 0) {
                pointName = pointNameInfo[engIndex];
              } else {
                pointName = pointNameInfo[0];
              }
            }
          }
        } else {
          pointName = pointNameInfo.isEmpty ? "" : pointNameInfo[0];
        }

        // * Set coordinate
        final StringBuffer builder = StringBuffer();
        builder.write("${info[1]},");
        builder.write(info[2]);
        final String positionInfo = builder.toString();
        final List<String> latLong = positionInfo.split(',');
        final double pointLatitude = double.parse(latLong[0]);
        final double pointLongitude = double.parse(latLong[1]);

        // * Set categoryList
        List<String> pointCategoryIdList = [];
        final List<String> categories = info[3].split("|");
        pointCategoryIdList = categories.map((category) => category).toList();

        final pointToAdd = PointDto(
          pointName: pointName,
          pointInfo: pointInfo,
          beaconId: null,
          coordinate: CoordinateDto(
            latitude: pointLatitude,
            longitude: pointLongitude,
          ),
          categoryIdStrList: pointCategoryIdList,
          id: Uuid().v4(),
        );

        facPointList.add(pointToAdd);
      }

      return FacilityScanCodeDto(
        brochureName: facBrochureName,
        pointList: facPointList,
        createdDate: createdDate,
        codeInfo: codeInfo,
        codeStr: codeStr,
      );
    } catch (e, st) {
      LogUtils.e('Failed to parse Facility Code', e, st);
      return null;
    }
  }

  Future<DocScanCodeDto> _decodeStandardDocCode(
    List<_CodeTag> codeTagList, {
    required String codeStr,
    required CodeInfoDto? codeInfo,
    required DateTime? createdDate,
  }) async {
    final Map<String, String> langKeyWithContent = {};

    for (final codeTag in codeTagList) {
      final String langKey = codeTag.key;
      final String finalLangKey = _standardizeLangKey(langKey);
      langKeyWithContent[finalLangKey] = codeTag.value;
    }

    // Find the content in the language of setting language
    final settingLangKeyIndex = await _findSettingLangKeyIndex(
      langKeyWithContent.keys.toList(),
    );
    // Use that content to assign default title
    final String defaultTitle = _getTitleFromContent(
      langKeyWithContent.values.elementAt(settingLangKeyIndex),
    );

    return DocScanCodeDto(
      createdDate: createdDate,
      name: defaultTitle,
      langKeyWithContent: langKeyWithContent,
      codeInfo: codeInfo,
      codeStr: codeStr,
      hasSyncOnline: false,
    );
  }

  DocScanCodeDto _decodeLegacyDocCode(
    String cleanedCodeStr, {
    required String codeStr,
    required CodeInfoDto? codeInfo,
    required String? legacyDocCodeLangKey,
    required DateTime? createdDate,
  }) {
    // Legacy Doc Code

    final langKey = _standardizeLangKey(legacyDocCodeLangKey ?? '.jpn');

    return DocScanCodeDto(
      createdDate: createdDate,
      name: _getTitleFromContent(cleanedCodeStr),
      langKeyWithContent: {langKey: cleanedCodeStr},
      codeInfo: codeInfo,
      codeStr: codeStr,
      hasSyncOnline: false,
    );
  }

  /// `uncleanLangKey`: Could be 'jpn' or '.jpn'
  ///
  /// `output`: '.jpn'
  String _standardizeLangKey(String uncleanLangKey) {
    return uncleanLangKey[0] == '.' ? uncleanLangKey : '.$uncleanLangKey';
  }

  Future<int> _findSettingLangKeyIndex(List<String> langKeyList) async {
    final settingLangKey = await _languageSettingRepository.getCurrentLangKey();

    if (settingLangKey == null) {
      return 0;
    }

    final foundIndex = langKeyList.indexOf(settingLangKey);

    return foundIndex == -1 ? 0 : foundIndex;
  }

  String _getTitleFromContent(String content) {
    final trimmedContent = content.replaceAll(
      RegexUtils.patternNewLine,
      ' ',
    );
    final int _numberOfCharacter = _checkCodeIs1Byte(trimmedContent) ? 46 : 23;

    return trimmedContent.length > _numberOfCharacter
        ? '${trimmedContent.substring(0, _numberOfCharacter)}...'
        : trimmedContent;
  }

  bool _checkCodeIs1Byte(String content) {
    final List<int> bytes = utf8.encode(content[0]);
    if (bytes.length > 1) {
      return false;
    }

    return true;
  }

  CodeInfoDto? _extractCodeInfo(List<_CodeTag> subCodeTagList) {
    final foundInfoTag = subCodeTagList.firstWhereOrNull(
      (codeTag) => codeTag.key == '%ci' || codeTag.key == '.%ci',
    );

    if (foundInfoTag == null) {
      return null;
    }

    // 466          codeId
    // 2            companyId
    // 32           projectId
    // https://...  originalURL

    final valueList = foundInfoTag.value.split('\n');
    if (valueList.length >= 3) {
      final codeInfo = CodeInfoDto(
        codeId: valueList[0],
        companyId: valueList[1],
        projectId: valueList[2],
        originalUrl: valueList.length >= 4 ? valueList[3] : null,
      );
      LogUtils.iNoST(
        'codeId: ${codeInfo.codeId}\n'
        'companyId: ${codeInfo.companyId}\n'
        'projectId: ${codeInfo.projectId}\n',
      );
      return codeInfo;
    }

    return null;
  }
}
