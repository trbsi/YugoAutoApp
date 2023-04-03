import 'dart:async';

import 'package:YugoAuto/services/device/DeviceService.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyCustomWebView extends StatefulWidget {
  const MyCustomWebView({Key? key}) : super(key: key);

  @override
  State<MyCustomWebView> createState() => _MyCustomWebViewState();
}

class _MyCustomWebViewState extends State<MyCustomWebView> {
  bool _isConnected = true;
  bool _showLoader = false;

  final String _mainUrl = 'https://yugoauto.com';
  final String _mainUrlWithWww = 'https://www.yugoauto.com';

  late StreamSubscription<ConnectivityResult> _subscription;
  late final WebViewController _webViewController;

  final DeviceService _deviceService = DeviceService();

  @override
  initState() {
    super.initState();
    _checkConnectivity();
    _setWebView();
  }

  @override
  dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected) {
      (_showLoader == true)
          ? context.loaderOverlay.show()
          : context.loaderOverlay.hide();
      return SafeArea(
        child: WebViewWidget(controller: _webViewController),
      );
    }

    return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Image.asset('assets/images/no_internet.png'));
  }

  void _checkConnectivity() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() => _isConnected = false);
      } else {
        setState(() => _isConnected = true);
      }
    });
  }

  void _setWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress < 100) {
              setState(() => _showLoader = true);
            } else {
              setState(() => _showLoader = false);
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            String deviceId = await _deviceService.getDeviceId();
            String platform = _deviceService.getPlatform();
            _webViewController.runJavaScript('savePushToken("token","' +
                deviceId +
                '", "' +
                platform +
                '");');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (!request.url.startsWith(_mainUrl) &&
                !request.url.startsWith(_mainUrlWithWww)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_mainUrl));
  }
}
