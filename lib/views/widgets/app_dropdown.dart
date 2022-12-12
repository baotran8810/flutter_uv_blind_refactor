import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:get/get.dart';

class AppDropdown<T> extends StatelessWidget {
  final String semanticsLabel;
  final T currentValue;
  final List<T> valueList;
  final String Function(T value) getDisplayText;
  final void Function(T? newValue) onChanged;
  final Widget? icon;
  final bool isExpanded;
  final bool showCheck;
  final double? buttonWidth;
  final double? buttonHeight;

  AppDropdown({
    Key? key,
    required this.semanticsLabel,
    required this.currentValue,
    required this.valueList,
    required this.getDisplayText,
    required this.onChanged,
    this.icon,
    this.isExpanded = false,
    this.showCheck = false,
    this.buttonHeight,
    this.buttonWidth,
  }) : super(key: key);

  final SemanticsManageController _semanticsManageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppSemantics(
      labelList: [
        semanticsLabel,
        getDisplayText(currentValue),
      ],
      isButton: true,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          alignment: AlignmentDirectional.centerEnd,
          icon: icon ??
              RotatedBox(
                quarterTurns: 1,
                child: Image.asset(AppAssets.iconChevronRight),
              ),
          isExpanded: isExpanded,
          value: currentValue,
          items: valueList
              .map<DropdownMenuItem<T>>(
                (value) => DropdownMenuItem<T>(
                  value: value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDisplayText(value),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (value == currentValue && showCheck)
                        Image.asset(AppAssets.iconCheckGreen)
                    ],
                  ),
                ),
              )
              .toList(),
          onTap: () {
            // Focus back to previous widget after dropdown closed
            _semanticsManageController.queueFocusing();
          },
          onChanged: (T? newValue) {
            onChanged(newValue);
            _semanticsManageController.focusQueueing();
          },
          itemWidth: 180,
          buttonWidth: buttonWidth,
          buttonHeight: buttonHeight,
        ),
      ),
    );
  }
}
