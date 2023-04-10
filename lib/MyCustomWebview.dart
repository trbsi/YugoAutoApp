import 'dart:async';

import 'package:YugoAuto/services/core/UrlService.dart';
import 'package:YugoAuto/services/notifications/PushService.dart';
import 'package:YugoAuto/services/webview/WebviewCoreService.dart';
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

  late StreamSubscription<ConnectivityResult> _subscription;
  late final WebViewController _webViewController;

  final PushService _pushService = PushService();
  final WebviewCoreService _webviewCoreService = WebviewCoreService();

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
      (_showLoader == true) ? context.loaderOverlay.show() : context.loaderOverlay.hide();
      return Container(
          color: Colors.white,
          child: SafeArea(
              child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: WebViewWidget(controller: _webViewController),
          )));
    }

    return Container(
        alignment: Alignment.center, color: Colors.white, child: Image.asset('assets/images/no_internet.png'));
  }

  void _checkConnectivity() {
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
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
      ..setNavigationDelegate(_navigationDelegate())
      ..loadRequest(Uri.parse(UrlService.mainUrl()));
  }

  NavigationDelegate _navigationDelegate() {
    return NavigationDelegate(
      onProgress: (int progress) {},
      onPageStarted: (String url) {
        setState(() => _showLoader = true);
      },
      onPageFinished: _onPageFinished,
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: _onNavigationRequest,
    );
  }

  void _onPageFinished(String url) async {
    setState(() => _showLoader = false);

    //implement this function on web app
    Object isUserAuthenticated = await _webViewController.runJavaScriptReturningResult('isUserAuthenticated()');

    if (isUserAuthenticated.toString() == 'true') {
      String? command = await _pushService.getPushTokenJavascriptCommand();
      if (command != null) {
        _webViewController.runJavaScript(command);
      }
    }
  }

  FutureOr<NavigationDecision> _onNavigationRequest(NavigationRequest request) {
    if (request.url.startsWith(UrlService.mainUrlWithRedirect()) ||
        request.url.startsWith(UrlService.mainUrlWithRedirect(withWww: true))) {
      _webviewCoreService.launchURL(request.url);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith(UrlService.mainUrl()) || request.url.startsWith(UrlService.mainUrl(withWww: true))) {
      return NavigationDecision.navigate;
    }

    _webviewCoreService.launchURL(request.url);
    return NavigationDecision.prevent;
  }
}
