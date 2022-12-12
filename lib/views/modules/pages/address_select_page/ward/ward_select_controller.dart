import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';

abstract class WardSelectController {
  bool get isLoadingAddressList;

  List<AddressDto> get wardList;

  Future<void> updateLocation(AddressDto addressDto);

  TagData? get currentAddress;
}
