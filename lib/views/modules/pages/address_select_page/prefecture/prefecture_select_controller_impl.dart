import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/address_repository/address_repository.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/prefecture/prefecture_select_controller.dart';
import 'package:get/get.dart';

class PrefectureSelectControllerImpl extends GetxController
    implements PrefectureSelectController {
  final AddressRepository _addressRepository;

  PrefectureSelectControllerImpl({
    required AddressRepository addressRepository,
  }) : _addressRepository = addressRepository;
  final List<String> _prefectureNames = [];

  final Rx<List<AddressDto>> _addressList = Rx([]);
  @override
  List<AddressDto> get prefectureList => _addressList.value;

  final Rx<bool> _isLoading = false.obs;
  @override
  bool get isLoadingAddressList => _isLoading.value;

  final Rx<TagData?> _currentAddressTagData = Rx(null);
  @override
  TagData? get currentAddressTagData => _currentAddressTagData.value;

  @override
  void onInit() {
    super.onInit();
    _getAddressList();
    _getCurrentAddressTagData();
  }

  Future<void> _getAddressList() async {
    try {
      _isLoading.value = true;
      final List<AddressDto> addresses =
          await _addressRepository.getAddressList();

      _addressList.value.assignAll(addresses.where((a) {
        if (!_prefectureNames.contains(a.prefectureName)) {
          _prefectureNames.add(a.prefectureName);
          return true;
        }

        return false;
      }).toList());
    } catch (e) {
      // Delay to work around for the case:
      // Internet not available => Open dialog as soon as entering the page
      // => VoiceOver will be messed up
      await Future.delayed(Duration(seconds: 1));

      await DialogViewUtils.showAlertDialog(
        messageText: tra(LocaleKeys.txt_noNetworkSettingLate),
      );
      Get.offAndToNamed(AppRoutes.scan);
    } finally {
      _isLoading.value = false;
    }
  }

  void _getCurrentAddressTagData() {
    _currentAddressTagData.value =
        _addressRepository.getCurrentAddressTagData();
  }
}
