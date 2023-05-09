import 'package:YugoAuto/services/device/DeviceService.dart';
import 'package:YugoAuto/services/notifications/FirebaseService.dart';
import 'package:get_storage/get_storage.dart';

class PushService {
  static String TOKEN_KEY = 'token';
  static String OLD_TOKEN_KEY = 'old_token';
  static String LAST_TIME_KEY = 'last_saved_time';
  static int TOKEN_RESET_TIME = 3600; //1h

  final DeviceService _deviceService = DeviceService();
  final GetStorage _storage = GetStorage();
  final FirebaseService _firebaseService = FirebaseService();

  Future<String?> getPushTokenJavascriptCommand() async {
    bool shouldSavePushToken = _shouldSavePushToken();
    String? token = _storage.read(PushService.TOKEN_KEY);

    if (null == token || false == shouldSavePushToken) {
      return null;
    }

    String deviceId = await _deviceService.getDeviceId();
    String platform = _deviceService.getPlatform();
    //for this to work you have to implement this JS function in your web app
    return 'savePushToken("$token", "$deviceId", "$platform");';
  }

  bool _shouldSavePushToken() {
    String? activeToken = _storage.read(PushService.TOKEN_KEY);
    String? oldToken = _storage.read(PushService.OLD_TOKEN_KEY);
    int? lastSaveTime = _storage.read(PushService.LAST_TIME_KEY);
    int now = ((DateTime.now().millisecondsSinceEpoch) / 1000).toInt();

    if (null == lastSaveTime || (now - lastSaveTime > PushService.TOKEN_RESET_TIME)) {
      _firebaseService.savePushToken();
      _storage.write(PushService.LAST_TIME_KEY, now);
      return true;
    }

    if (activeToken == null) {
      return false;
    }

    if (activeToken != oldToken) {
      _storage.write(PushService.OLD_TOKEN_KEY, activeToken);
      return true;
    }
    return false;
  }
}
