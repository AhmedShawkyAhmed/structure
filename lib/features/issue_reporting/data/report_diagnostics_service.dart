import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReportDiagnosticsService {
  const ReportDiagnosticsService();

  Future<Map<String, Object?>> collect() async {
    final app = await PackageInfo.fromPlatform();
    final result = <String, Object?>{
      'appVersion': app.version,
      'appBuild': app.buildNumber,
      'platform': defaultTargetPlatform.name,
    };
    try {
      final native = await const MethodChannel(
        'com.shawky.structure/device_info',
      ).invokeMapMethod<String, dynamic>('getDeviceData');
      final hardware = native?['Hardware'];
      final os = native?['Operating system'];
      // Allowlist only the details shown in the report's consent controls.
      if (hardware is Map) {
        result['deviceModel'] = hardware['model'];
      }
      if (os is Map) {
        result['osVersion'] = os['version'] ?? os['release'];
      }
    } on PlatformException {
      // App details are still useful when native details are unavailable.
    } on MissingPluginException {
      // Desktop/test environments may not have the native channel.
    }
    return result;
  }
}
