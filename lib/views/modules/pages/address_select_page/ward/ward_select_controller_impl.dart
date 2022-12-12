import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/address_repository/address_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/push_notif_service/push_notif_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/ward/ward_select_controller.dart';
import 'package:get/get.dart';

class WardSelectControllerImpl extends GetxController
    implements WardSelectController {
  final PushNotifService _notificationService;
  final AddressRepository _addressRepository;
  final String _prefectureName;

  WardSelectControllerImpl({
    required AddressRepository addressRepository,
    required PushNotifService notificationService,
    required String prefectureName,
  })  : _notificationService = notificationService,
        _addressRepository = addressRepository,
        _prefectureName = prefectureName;

  final Rx<List<AddressDto>> _addressList = Rx([]);

  @override
  List<AddressDto> get wardList => _addressList.value
      .where((a) => a.prefectureName == _prefectureName)
      .toList();

  final Rx<bool> _isLoading = false.obs;

  @override
  bool get isLoadingAddressList => _isLoading.value;

  final Rx<TagData?> _currentAddress = Rx(null);

  @override
  TagData? get currentAddress => _currentAddress.value;

  @override
  void onInit() {
    super.onInit();
    _getAddressList();
    _getCurrentAddress();
  }

  Future<void> _getAddressList() async {
    try {
      _isLoading.value = true;
      final List<AddressDto> addresses =
          await _addressRepository.getAddressList();
      _addressList.value.assignAll(addresses);
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

  void _getCurrentAddress() {
    _currentAddress.value = _addressRepository.getCurrentAddressTagData();
  }

  @override
  Future<void> updateLocation(AddressDto addressDto) async {
    _notificationService.updateLocation(addressDto.tagData);
    _addressRepository.setAddress(addressDto);
    _currentAddress.value = addressDto.tagData;
  }
}
