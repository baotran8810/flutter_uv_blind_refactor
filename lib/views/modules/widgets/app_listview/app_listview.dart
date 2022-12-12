import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_listview/app_listview_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_listview/app_listview_controller_impl.dart';
import 'package:get/get.dart';

class AppListView extends AppGetView<AppListViewController> {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  AppListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(
          key: key,
          initialController: AppListViewControllerImpl(),
        );

  @override
  Widget build(BuildContext context, AppListViewController controller) {
    return Obx(() {
      final isBlindModeOn = controller.isBlindModeOn;

      // Workaround because normal ListView has a lot of bugs
      // with voiceover ON (especially on iOS)
      if (isBlindModeOn) {
        return SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < itemCount; i++) ...{
                itemBuilder(
                  context,
                  i,
                )
              },
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    });
  }
}
