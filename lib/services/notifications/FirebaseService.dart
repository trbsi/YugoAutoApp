import 'dart:io';

import 'package:YugoAuto/services/notifications/FirebaseOptions.dart';
import 'package:YugoAuto/services/notifications/PushService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';

class FirebaseService {
  final GetStorage _storage = GetStorage();

  Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (Platform.isIOS) {
      _handleIOSPersmission();
    }

    if (Platform.isAndroid) {
      savePushToken();
      _listenToTokenChange();
    }
  }

  void savePushToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) {
      return;
    }
    _storage.write(PushService.TOKEN_KEY, fcmToken);
  }

  void _listenToTokenChange() {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      savePushToken();
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
      savePushToken();
      _listenToTokenChange();
    }
  }
}
