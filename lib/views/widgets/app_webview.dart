import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebview extends StatefulWidget {
  final String initialUrl;

  const AppWebview({
    Key? key,
    required this.initialUrl,
  }) : super(key: key);

  @override
  _AppWebviewState createState() => _AppWebviewState();
}

class _AppWebviewState extends State<AppWebview> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Loading to avoid janky on navigate transition
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });

      if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: AppLoading(),
      );
    }

    return WebView(
      initialUrl: widget.initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
