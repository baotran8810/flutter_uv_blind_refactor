import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/app_data/app_data_entity.dart';
import 'package:uuid/uuid.dart';

class AppDataDto {
  final bool isOnboardCompleted;
  final DateTime pollyLastModifiedAt;
  final String signLanguageId;
  final bool? hasMigratedFromOldApp;

  AppDataDto({
    required this.isOnboardCompleted,
    required this.pollyLastModifiedAt,
    required this.signLanguageId,
    required this.hasMigratedFromOldApp,
  });

  /// Default value when opening the app for the first time
  factory AppDataDto.initDefault() {
    return AppDataDto(
      isOnboardCompleted: false,
      pollyLastModifiedAt: DateTime(1700),
      signLanguageId: Uuid().v4(),
      hasMigratedFromOldApp: false,
    );
  }

  factory AppDataDto.fromEntity(AppDataEntity entity) {
    return AppDataDto(
      isOnboardCompleted: entity.isOnboardCompleted,
      pollyLastModifiedAt: entity.pollyLastModifiedAt,
      signLanguageId: entity.signLanguageId,
      hasMigratedFromOldApp: entity.hasMigratedFromOldApp,
    );
  }

  AppDataEntity toEntity() {
    return AppDataEntity(
      isOnboardCompleted: isOnboardCompleted,
      pollyLastModifiedAt: pollyLastModifiedAt,
      signLanguageId: signLanguageId,
      hasMigratedFromOldApp: hasMigratedFromOldApp,
    );
  }
}
