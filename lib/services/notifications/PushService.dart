import 'package:YugoAuto/services/device/DeviceService.dart';
import 'package:get_storage/get_storage.dart';

class PushService {
  static String TOKEN_KEY = 'token';
  static String OLD_TOKEN_KEY = 'old_token';

  final DeviceService _deviceService = DeviceService();
  final GetStorage _storage = GetStorage();

  Future<String?> getPushTokenJavascriptCommand() async {
    String? token = _storage.read(PushService.TOKEN_KEY);
    bool shouldSavePushToken = _shouldSavePushToken();
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
