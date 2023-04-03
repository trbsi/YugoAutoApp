import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_app_namespace/core/helpers/device_info_helper.dart';
import 'package:my_app_namespace/core/http/http_helper.dart';
import 'package:my_app_namespace/core/notifications/firebase_options.dart';
import 'package:my_app_namespace/core/storage/storage_helper.dart';
import 'package:my_app_namespace/core/user/helpers/user_helper.dart';

class FirebaseHelper {
  Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (Platform.isIOS) {
      _handleIOSPersmission();
    }

    if (Platform.isAndroid) {
      sendPushToken();
      _listenToTokenChange();
    }
  }

  void _listenToTokenChange() {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      sendPushToken();
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      print(err);
    });
  }

  /**
   * https://firebase.google.com/docs/cloud-messaging/flutter/receive#request_permission_to_receive_messages_apple_and_web
   */
  void _handleIOSPersmission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      sendPushToken();
      _listenToTokenChange();
    }
  }

  void sendPushToken() async {
    StorageHelper storage = StorageHelper();
    UserHelper user = UserHelper();
    HttpHelper http = HttpHelper();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    String deviceId = await DeviceInfoHelper().getDeviceId();
    String platform = Platform.isIOS ? 'ios' : 'android';

    if (fcmToken == null) {
      return;
    }

    //only authenticated user can save push token
    //save in storage to send to server later
    if (!user.isAuthenticated()) {
      storage.setPushToken(fcmToken);
      return;
    }

    Map data = {'deviceId': deviceId, 'platform': platform, 'token': fcmToken};
    http.makeRequest(endpoint: '/push-token', method: 'POST', data: data);
  }
}
