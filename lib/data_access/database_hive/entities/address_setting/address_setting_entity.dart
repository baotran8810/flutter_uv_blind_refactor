import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/base_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

part 'address_setting_entity.g.dart';

const String uniqueId = 'ADDRESS_SETTING';

@HiveType(typeId: HiveConst.addressSettingTid)
class AddressSettingEntity extends BaseEntity {
  @HiveField(1)
  final Map<String, dynamic>? currentAddress;
  @HiveField(2)
  final String? currentAddressName;

  AddressSettingEntity({
    required this.currentAddress,
    required this.currentAddressName,
  }) : super(id: uniqueId);
}
