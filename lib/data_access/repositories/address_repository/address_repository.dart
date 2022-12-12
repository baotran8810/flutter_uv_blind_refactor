import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';

abstract class AddressRepository {
  Future<List<AddressDto>> getAddressList();

  Future<void> setAddress(AddressDto addressDto);

  TagData? getCurrentAddressTagData();
  String? getCurrentAddressName();
}
