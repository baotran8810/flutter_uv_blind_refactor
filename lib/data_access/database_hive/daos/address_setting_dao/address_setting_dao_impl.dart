import 'package:flutter_uv_blind_refactor/data_access/database_hive/app_hive.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/address_setting_dao/address_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/address_setting/address_setting_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AddressSettingDaoImpl implements AddressSettingDao {
  final Box<AddressSettingEntity> _addressSetting;

  AddressSettingDaoImpl()
      : _addressSetting = Get.find<AppHive>().getBox<AddressSettingEntity>();

  @override
  TagData? getCurrentAddress() {
    final AddressSettingEntity? addressSettingEntity =
        _addressSetting.get(uniqueId);
    final Map<String, dynamic>? currentAddressJson =
        addressSettingEntity?.currentAddress;
    if (currentAddressJson != null) {
      return TagData.fromJson(currentAddressJson);
    }

    return null;
  }

  @override
  Future<void> setAddress(TagData tagData, String addressName) async {
    await _addressSetting.put(
        uniqueId,
        AddressSettingEntity(
          currentAddress: tagData.toJson(),
          currentAddressName: addressName,
        ));
    return Future.value();
  }

  @override
  String? getCurrentAddressName() {
    final AddressSettingEntity? addressSettingEntity =
        _addressSetting.get(uniqueId);
    return addressSettingEntity?.currentAddressName;
  }
}
