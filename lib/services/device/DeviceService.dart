import 'dart:io';

import 'package:platform_device_id/platform_device_id.dart';

class DeviceService {
  Future<String> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    if (deviceId == null) {
      return '';
    }

    return deviceId;
  }

  String getPlatform() {
    String platform;
    if (Platform.isAndroid) {
      platform = 'android';
    } else if (Platform.isIOS) {
      platform = 'ios';
    } else {
      platform = '';
    }
    return platform;
  }
}
