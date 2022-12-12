import 'package:flutter_uv_blind_refactor/data_access/apis/rest_client.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/address_setting_dao/address_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/address_repository/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressSettingDao _addressSettingDao;
  final RestClient _restClient;
  List<AddressDto>? _cachedAddressList;

  AddressRepositoryImpl({
    required RestClient restClient,
    required AddressSettingDao addressSettingDao,
  })  : _restClient = restClient,
        _addressSettingDao = addressSettingDao;

  @override
  Future<List<AddressDto>> getAddressList() async {
    _cachedAddressList ??= await _restClient.getAddressList();
    return Future.value(_cachedAddressList);
  }

  @override
  TagData? getCurrentAddressTagData() {
    return _addressSettingDao.getCurrentAddress();
  }

  @override
  Future<void> setAddress(AddressDto addressDto) async {
    _addressSettingDao.setAddress(
      addressDto.tagData,
      addressDto.getAddressName(),
    );
  }

  @override
  String? getCurrentAddressName() {
    return _addressSettingDao.getCurrentAddressName();
  }
}
