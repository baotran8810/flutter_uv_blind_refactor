import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/base_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

part 'language_setting_entity.g.dart';

const String uniqueId = 'LANGUAGE_SETTING';

@HiveType(typeId: HiveConst.languageSettingTid)
class LanguageSettingEntity extends BaseEntity {
  @HiveField(1)
  final String? currentLangKey;

  LanguageSettingEntity({
    required this.currentLangKey,
  }) : super(id: uniqueId);
}
