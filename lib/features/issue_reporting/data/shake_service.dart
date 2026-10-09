import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Requires three distinct acceleration peaks instead of one accidental bump.
class ShakeDetector {
  ShakeDetector({this.cooldown = const Duration(seconds: 4)});
  final Duration cooldown;
  final List<DateTime> _peaks = [];
  DateTime? _lastShake;
  bool _armed = true;

  bool add(double x, double y, double z, DateTime now) {
    final force = sqrt(x * x + y * y + z * z) / 9.81;
    if (force < 1.6) {
      _armed = true;
    }
    _peaks.removeWhere((time) => now.difference(time).inMilliseconds > 900);
    if (!_armed || force < 2.5) {
      return false;
    }
    _armed = false;
    if (_lastShake != null && now.difference(_lastShake!) < cooldown) {
      return false;
    }
    _peaks.add(now);
    if (_peaks.length < 3) {
      return false;
    }
    _peaks.clear();
    _lastShake = now;
    return true;
  }

  void reset() {
    _peaks.clear();
    _armed = true;
  }
}

class ShakeService {
  final _detector = ShakeDetector();
  StreamSubscription<AccelerometerEvent>? _subscription;

  void start(VoidCallback onShake) {
    if (_subscription != null ||
        kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }
    _subscription =
        accelerometerEventStream(
          samplingPeriod: const Duration(milliseconds: 50),
        ).listen(
          (event) {
            if (_detector.add(event.x, event.y, event.z, DateTime.now())) {
              onShake();
            }
          },
          onError: (Object error) {
            // The manual report action remains available without a sensor.
            unawaited(stop());
          },
        );
  }

  Future<void> stop() async {
    final subscription = _subscription;
    _subscription = null;
    _detector.reset();
    await subscription?.cancel();
  }
}
