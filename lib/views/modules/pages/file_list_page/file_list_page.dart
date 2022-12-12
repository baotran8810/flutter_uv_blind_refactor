import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/styles.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/file_list_page/file_list_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/file_list_page/file_list_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_inkwell.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/scan_code_list_view.dart';
import 'package:get/get.dart';

part 'widgets/code_list_section.dart';
part 'widgets/filter_btns_section.dart';

class FileListPage extends AppGetView<FileListPageController> {
  FileListPage({
    Key? key,
  }) : super(
            key: key,
            initialController: FileListPageControllerImpl(
              analyticsService: Get.find(),
              scanCodeRepository: Get.find(),
            ));

  @override
  Widget build(BuildContext context, FileListPageController controller) {
    return Obx(() {
      final selectedFilter = controller.selectedFilter;
      return BaseLayout(
        header: AppHeader(
          titleText: tra(LocaleKeys.titlePage_fileList),
          semanticsTitle: tra(LocaleKeys.semTitlePage_fileList),
          helpScript: tra(LocaleKeys.helpScript_fileList),
          // TODO use AppHeader's sub actions
          bottomChild: _FilterBtnsSection(
            selectedFilter: selectedFilter,
            onPressedFilter: (filter) {
              controller.toggleFilter(filter);
            },
          ),
        ),
        body: _buildBody(context, controller),
      );
    });
  }

  Widget _buildBody(BuildContext context, FileListPageController controller) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                final scanCodeList = controller.scanCodeList;

                return _CodeListSection(
                  scanCodeList: scanCodeList,
                  onPressedItem: (scanCode) {
                    controller.goToPage(scanCode);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
