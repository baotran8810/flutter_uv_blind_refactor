// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_scan_code_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension DocScanCodeDtoCopyWith on DocScanCodeDto {
  DocScanCodeDto copyWith({
    CodeInfoDto? codeInfo,
    String? codeStr,
    DateTime? createdDate,
    bool? hasSyncOnline,
    String? id,
    bool? isBookmark,
    Map<String, String>? langKeyWithContent,
    String? name,
  }) {
    return DocScanCodeDto(
      codeInfo: codeInfo ?? this.codeInfo,
      codeStr: codeStr ?? this.codeStr,
      createdDate: createdDate ?? this.createdDate,
      hasSyncOnline: hasSyncOnline ?? this.hasSyncOnline,
      id: id ?? this.id,
      isBookmark: isBookmark ?? this.isBookmark,
      langKeyWithContent: langKeyWithContent ?? this.langKeyWithContent,
      name: name ?? this.name,
    );
  }
}
