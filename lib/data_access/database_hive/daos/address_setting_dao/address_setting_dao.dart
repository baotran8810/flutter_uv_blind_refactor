import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';

abstract class AddressSettingDao {
  TagData? getCurrentAddress();
  String? getCurrentAddressName();

  Future<void> setAddress(TagData tagData, String addressName);
}
