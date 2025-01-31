import 'dart:io';

import 'flashlight_platform_interface.dart';
import 'package:flutter/services.dart';

class Flashlight {
  static const MethodChannel _channel = MethodChannel('flashlight_plugin');
  Future<String?> getPlatformVersion() {

    return FlashlightPlatform.instance.getPlatformVersion();
  }

  static Future<void> onLight(bool isOn) async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('toggleLight', {'isOn': isOn});
    } else {
      // Виводимо попередження для iOS або інших платформ
      throw UnsupportedError('Flashlight control is not supported on this platform.');
    }
  }
}
