import 'dart:async';

import 'package:flutter_udid/flutter_udid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

typedef DeviceUdidReader = Future<String> Function();
typedef DeviceUuidFactory = String Function();

/// The backend ID is chosen once and is never changed by a later UDID read.
/// A fallback cannot survive reinstall if app preferences are removed.
class DeviceIdentityService {
  DeviceIdentityService({
    SharedPreferencesAsync? preferences,
    DeviceUdidReader? readUdid,
    DeviceUuidFactory? createFallback,
  }) : _preferences = preferences ?? SharedPreferencesAsync(),
       _readUdid = readUdid ?? (() => FlutterUdid.udid),
       _createFallback = createFallback ?? (() => const Uuid().v4());

  static final DeviceIdentityService instance = DeviceIdentityService();

  static const String selectedIdKey = 'device.selected_id';
  static const String flutterUdidKey = 'device.flutter_udid';
  static const String fallbackUuidKey = 'device.random_fallback';
  static const String sourceKey = 'device.selected_source';

  final SharedPreferencesAsync _preferences;
  final DeviceUdidReader _readUdid;
  final DeviceUuidFactory _createFallback;
  Future<String>? _initialization;
  Future<void>? _backgroundRefresh;

  /// Reads the selected ID from preferences for every request.
  Future<String> getSelectedId() async {
    final String? saved = await _preferences.getString(selectedIdKey);
    if (saved != null && saved.isNotEmpty) {
      if (await _preferences.getString(flutterUdidKey) == null) {
        final Future<void> refresh = _backgroundRefresh ??=
            _refreshInBackground();
        unawaited(refresh);
      }
      return saved;
    }

    final Future<String> pending = _initialization ??= _initialize();
    try {
      return await pending;
    } finally {
      if (identical(_initialization, pending)) {
        _initialization = null;
      }
    }
  }

  Future<String> _initialize() async {
    // Another request may have completed initialization while this one waited.
    final String? saved = await _preferences.getString(selectedIdKey);
    if (saved != null && saved.isNotEmpty) {
      return saved;
    }

    // Persist the reserve ID before selecting it. Both IDs are retained when
    // FlutterUdid is available, so a later platform failure cannot rotate it.
    String? fallback = await _preferences.getString(fallbackUuidKey);
    if (fallback == null || fallback.isEmpty) {
      fallback = _createFallback();
      await _preferences.setString(fallbackUuidKey, fallback);
    }

    String? udid;
    try {
      final String value = (await _readUdid()).trim();
      if (value.isNotEmpty) {
        udid = value;
      }
    } on Object {
      // A platform/Keychain error only affects the first selection. The
      // persisted fallback remains stable through later logout and login.
    }

    if (udid != null) {
      await _preferences.setString(flutterUdidKey, udid);
    }

    final String selected = udid ?? fallback;
    await _preferences.setString(
      sourceKey,
      udid == null ? 'fallback' : 'flutter_udid',
    );
    await _preferences.setString(selectedIdKey, selected);
    return selected;
  }

  /// Save a UDID that becomes available later without replacing the backend ID.
  Future<void> refreshFlutterUdid() async {
    String udid;
    try {
      udid = (await _readUdid()).trim();
    } on Object {
      return;
    }
    if (udid.isNotEmpty) {
      await _preferences.setString(flutterUdidKey, udid);
    }
  }

  Future<void> _refreshInBackground() async {
    try {
      await refreshFlutterUdid();
    } on Object {
      // Saving a diagnostic UDID must not interrupt a request that already
      // has a persisted backend ID.
    } finally {
      _backgroundRefresh = null;
    }
  }

  Future<DeviceIdentitySnapshot> snapshot() async {
    final String selectedId = await getSelectedId();
    return DeviceIdentitySnapshot(
      selectedId: selectedId,
      flutterUdid: await _preferences.getString(flutterUdidKey),
      fallbackUuid: await _preferences.getString(fallbackUuidKey),
      source: await _preferences.getString(sourceKey) ?? 'unknown',
    );
  }
}

class DeviceIdentitySnapshot {
  const DeviceIdentitySnapshot({
    required this.selectedId,
    required this.flutterUdid,
    required this.fallbackUuid,
    required this.source,
  });

  final String selectedId;
  final String? flutterUdid;
  final String? fallbackUuid;
  final String source;
}
