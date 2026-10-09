import 'package:flutter_test/flutter_test.dart';
import 'package:structure/features/issue_reporting/data/shake_service.dart';

void main() {
  test('ignores ordinary movement and a sustained acceleration peak', () {
    final detector = ShakeDetector();
    final now = DateTime(2026);
    for (var i = 0; i < 20; i++) {
      expect(detector.add(0, 0, 9.81, now), false);
      expect(detector.add(2, 2, 10, now), false);
    }
    for (var i = 0; i < 20; i++) {
      expect(detector.add(30, 0, 0, now), false);
    }
  });

  test('requires three separated peaks in a short window and a cooldown', () {
    final detector = ShakeDetector();
    final now = DateTime(2026);
    bool peak(int milliseconds) {
      final time = now.add(Duration(milliseconds: milliseconds));
      detector.add(0, 0, 9.81, time);
      return detector.add(30, 0, 0, time);
    }

    expect(peak(0), false);
    expect(peak(200), false);
    expect(peak(400), true);
    expect(peak(600), false);
    expect(peak(800), false);
    expect(peak(1000), false);
    expect(peak(5000), false);
    expect(peak(5200), false);
    expect(peak(5400), true);
  });

  test('spaced-out bumps and a background reset do not count as shaking', () {
    final detector = ShakeDetector();
    final now = DateTime(2026);
    for (var i = 0; i < 4; i++) {
      final time = now.add(Duration(seconds: i * 2));
      detector.add(0, 0, 9.81, time);
      expect(detector.add(30, 0, 0, time), false);
    }
    detector.reset();
    expect(detector.add(30, 0, 0, now.add(const Duration(seconds: 7))), false);
  });
}
