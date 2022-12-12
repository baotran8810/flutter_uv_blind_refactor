import 'dart:async';

import 'package:flutter_uv_blind_refactor/common/utility/extensions/list_extension.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/rest_client.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/scan_code_dao/scan_code_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_sqlite/daos/scan_code_sql_dao/scan_code_sql_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';

class ScanCodeRepositoryImpl implements ScanCodeRepository {
  final ScanCodeDao _scanCodeDao;
  final ScanCodeSqlDao _scanCodeSqlDao;
  final RestClient _restClient;

  ScanCodeRepositoryImpl({
    required ScanCodeDao scanCodeDao,
    required ScanCodeSqlDao scanCodeSqlDao,
    required RestClient restClient,
  })  : _scanCodeDao = scanCodeDao,
        _scanCodeSqlDao = scanCodeSqlDao,
        _restClient = restClient;

  @override
  Future<void> updateName(String id, String name) async {
    final foundScanCode = _scanCodeDao.getScanCodeById(id);
    if (foundScanCode == null) {
      return;
    }

    foundScanCode.setName(name);

    unawaited(_scanCodeSqlDao.updateScanCode(id, foundScanCode));
    await _scanCodeDao.setScanCode(foundScanCode);
  }

  @override
  Future<void> updateIsBookmark(String id) async {
    final foundScanCode = _scanCodeDao.getScanCodeById(id);
    if (foundScanCode == null) {
      return;
    }

    foundScanCode.setIsBookmark(!foundScanCode.isBookmark);

    unawaited(_scanCodeSqlDao.updateScanCode(id, foundScanCode));
    await _scanCodeDao.setScanCode(foundScanCode);
  }

  /// Find the existing scan code with the same codeStr, then:
  /// - Add if not found
  /// - Update if found
  @override
  Future<List<ScanCodeDto>> addOrUpdateScanCodeList(
    List<ScanCodeDto> scanCodeList,
  ) async {
    final futureList =
        scanCodeList.map((scanCode) => _addOrUpdateScanCode(scanCode)).toList();

    await Future.wait(futureList);
    return _scanCodeDao.getAllScanCodeList();
  }

  Future<void> _addOrUpdateScanCode(ScanCodeDto scanCode) async {
    final foundScanCodeWithCodeStr = getAllScanCode().firstWhereOrNull(
      (item) =>
          item.codeStr != null &&
          scanCode.codeStr != null &&
          item.codeStr == scanCode.codeStr,
    );

    if (foundScanCodeWithCodeStr == null) {
      // Add
      unawaited(_scanCodeSqlDao.addScanCode(scanCode));
      await _scanCodeDao.setScanCode(scanCode);
    } else {
      // Update
      scanCode.id = foundScanCodeWithCodeStr.id;
      unawaited(_scanCodeSqlDao.updateScanCode(scanCode.id, scanCode));
      await _scanCodeDao.setScanCode(scanCode);
    }
  }

  @override
  List<ScanCodeDto> getAllScanCode() {
    return _scanCodeDao.getAllScanCodeList();
  }

  @override
  Future<List<ScanCodeDto>> deleteScanCode(String id) async {
    unawaited(_scanCodeSqlDao.deleteScanCode(id));
    return await _scanCodeDao.deleteScanCode(id);
  }

  @override
  Future<DocScanCodeDto> syncDocScanCode(DocScanCodeDto docScanCode) async {
    final codeId = docScanCode.codeInfo?.codeId;

    if (docScanCode.hasSyncOnline || codeId == null) {
      return docScanCode;
    }

    try {
      final response = await _restClient.getDocOnlineContent(codeId);
      final onlineCodeTagList = response.data?.codes;
      if (onlineCodeTagList == null || onlineCodeTagList.isEmpty) {
        return docScanCode;
      }

      // Start applying new doc code's content from online.

      final newLangKeyWithContent =
          Map<String, String>.from(docScanCode.langKeyWithContent);

      for (final codeTag in onlineCodeTagList) {
        final langKey = codeTag.lang;
        final langText = codeTag.text;
        if (langKey == null || langText == null) {
          continue;
        }

        final String finalLangKey = _standardizeLangKey(langKey);
        newLangKeyWithContent[finalLangKey] = langText;
      }

      final newDocScanCode = docScanCode.copyWith(
        langKeyWithContent: newLangKeyWithContent,
        hasSyncOnline: true,
      );

      unawaited(_scanCodeSqlDao.updateScanCode(
        newDocScanCode.id,
        newDocScanCode,
      ));
      await _scanCodeDao.setScanCode(newDocScanCode);
      return newDocScanCode;
    } catch (e) {
      LogUtils.e('Error fetching online doc code', e);
      // Failed to get online content
      return docScanCode;
    }
  }

  /// `uncleanLangKey`: Could be 'jpn' or '.jpn'
  ///
  /// `output`: '.jpn'
  String _standardizeLangKey(String uncleanLangKey) {
    return uncleanLangKey[0] == '.' ? uncleanLangKey : '.$uncleanLangKey';
  }
}
