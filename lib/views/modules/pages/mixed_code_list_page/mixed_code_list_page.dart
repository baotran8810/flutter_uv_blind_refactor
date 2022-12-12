import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/scan_code_list_view.dart';

class MixedCodeListPageArguments {
  final List<ScanCodeDto> scanCodeList;

  MixedCodeListPageArguments({
    required this.scanCodeList,
  });
}

class MixedCodeListPage extends StatelessWidget {
  final MixedCodeListPageArguments arguments;

  const MixedCodeListPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      header: AppHeader(
        titleText: 'Uni-Voice',
        helpScript: tra(LocaleKeys.helpScript_fileList),
      ),
      body: ScanCodeListView(
        scanCodeList: arguments.scanCodeList,
      ),
    );
  }
}
