import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';

abstract class PrefectureSelectController {
  bool get isLoadingAddressList;
  List<AddressDto> get prefectureList;
  TagData? get currentAddressTagData;
}
