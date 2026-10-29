import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NotificationSettingsService {
  static const _channel = MethodChannel('insulog/settings');

  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<bool> openSettings() async {
    if (!isSupported) return false;
    try {
      return await _channel.invokeMethod<bool>('openNotificationSettings') ??
          false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
