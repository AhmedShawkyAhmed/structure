import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:structure/core/services/device_identity_service.dart';

class DeviceSnapshot {
  const DeviceSnapshot({required this.sections, required this.capturedAt});

  final Map<String, Map<String, Object?>> sections;
  final DateTime capturedAt;

  Map<String, Object?> toJson() => <String, Object?>{
    'capturedAt': capturedAt.toIso8601String(),
    ...sections,
  };

  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());
}

class DeviceDiagnosticsService {
  DeviceDiagnosticsService({
    this._channel = const MethodChannel('com.shawky.structure/device_info'),
  });

  final MethodChannel _channel;

  Future<DeviceSnapshot> collect({
    required Size logicalSize,
    required double devicePixelRatio,
    required double textScaleFactor,
    required Brightness platformBrightness,
  }) async {
    final PackageInfo app = await PackageInfo.fromPlatform();
    final Map<String, Map<String, Object?>> sections =
        <String, Map<String, Object?>>{
          'App': <String, Object?>{
            'name': app.appName,
            'package': app.packageName,
            'version': app.version,
            'buildNumber': app.buildNumber,
            if (app.buildSignature.isNotEmpty)
              'buildSignature': app.buildSignature,
            if (app.installerStore?.isNotEmpty ?? false)
              'installerStore': app.installerStore,
          },
          'Display': <String, Object?>{
            'logicalWidth': _round(logicalSize.width),
            'logicalHeight': _round(logicalSize.height),
            'physicalWidth': _round(logicalSize.width * devicePixelRatio),
            'physicalHeight': _round(logicalSize.height * devicePixelRatio),
            'devicePixelRatio': _round(devicePixelRatio),
            'textScaleFactor': _round(textScaleFactor),
            'platformBrightness': platformBrightness.name,
          },
          'Runtime': <String, Object?>{
            'platform': defaultTargetPlatform.name,
            'isWeb': kIsWeb,
            'locale': PlatformDispatcher.instance.locale.toLanguageTag(),
            'preferredLocales': PlatformDispatcher.instance.locales
                .map((Locale locale) => locale.toLanguageTag())
                .toList(),
            'buildMode': kReleaseMode
                ? 'release'
                : kProfileMode
                ? 'profile'
                : 'debug',
          },
        };

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      try {
        final DeviceIdentityService identity = DeviceIdentityService.instance;
        final String selectedId = await identity.getSelectedId();
        await identity.refreshFlutterUdid();
        final DeviceIdentitySnapshot saved = await identity.snapshot();

        debugPrint('SELECTED_DEVICE_ID: $selectedId');

        sections['Identity'] = <String, Object?>{
          'selectedId': saved.selectedId,
          'source': saved.source,
          'flutterUdid': saved.flutterUdid,
          'randomFallback': saved.fallbackUuid,
          'scopeNote':
              'The selected ID stays fixed while app preferences exist. '
              'A later FlutterUdid result is saved but never replaces it.',
        };
      } on Object catch (error) {
        sections['Identity'] = <String, Object?>{
          'status': 'Unavailable',
          'error': error.toString(),
        };
      }

      try {
        final Map<Object?, Object?>? native = await _channel
            .invokeMapMethod<Object?, Object?>('getDeviceData');
        if (native != null) {
          for (final MapEntry<Object?, Object?> entry in native.entries) {
            final Object? value = _normalise(entry.value);
            if (value is Map<String, Object?>) {
              sections[entry.key.toString()] = value;
            }
          }
        }
      } on PlatformException catch (error) {
        sections['Native collection'] = <String, Object?>{
          'status': 'Unavailable',
          'error': error.message ?? error.code,
        };
      } on MissingPluginException {
        sections['Native collection'] = <String, Object?>{
          'status': 'Unavailable on this platform',
        };
      }
    }

    final DeviceSnapshot snapshot = DeviceSnapshot(
      sections: sections,
      capturedAt: DateTime.now(),
    );
    debugPrint(
      'DEVICE DIAGNOSTICS\n${snapshot.toPrettyJson()}',
      wrapWidth: 1024,
    );
    return snapshot;
  }

  static double _round(double value) => (value * 100).roundToDouble() / 100;

  static Object? _normalise(Object? value) {
    if (value is Map<Object?, Object?>) {
      return value.map<String, Object?>(
        (Object? key, Object? nestedValue) =>
            MapEntry<String, Object?>(key.toString(), _normalise(nestedValue)),
      );
    }
    if (value is List<Object?>) {
      return value.map<Object?>(_normalise).toList();
    }
    return value;
  }
}
