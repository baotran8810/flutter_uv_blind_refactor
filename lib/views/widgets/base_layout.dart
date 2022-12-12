import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';

class BaseLayout extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Color backgroundColor;
  final bool hasSafeAreaBody;

  const BaseLayout({
    required this.header,
    required this.body,
    this.backgroundColor = AppColors.screenBg,
    this.hasSafeAreaBody = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.headerBorderColor,
                      width: 1.5,
                    ),
                  ),
                ),
                child: header,
              ),
            ),
            Expanded(
              child: hasSafeAreaBody
                  ? SafeArea(
                      top: false,
                      child: body,
                    )
                  : body,
            ),
          ],
        ),
      ),
    );
  }
}
