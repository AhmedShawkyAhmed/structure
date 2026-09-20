import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:structure/core/services/device_identity_service.dart';

class _MockPreferences extends Mock implements SharedPreferencesAsync {}

void main() {
  late _MockPreferences preferences;
  late Map<String, String> values;

  setUp(() {
    preferences = _MockPreferences();
    values = <String, String>{};
    when(() => preferences.getString(any())).thenAnswer(
      (Invocation invocation) async =>
          values[invocation.positionalArguments.first as String],
    );
    when(() => preferences.setString(any(), any())).thenAnswer((
      Invocation invocation,
    ) async {
      values[invocation.positionalArguments[0] as String] =
          invocation.positionalArguments[1] as String;
    });
  });

  test('uses FlutterUdid first and saves both identifiers', () async {
    var reads = 0;
    final service = DeviceIdentityService(
      preferences: preferences,
      readUdid: () async {
        reads++;
        return 'platform-id';
      },
      createFallback: () => 'random-uuid',
    );

    expect(await service.getSelectedId(), 'platform-id');
    expect(await service.getSelectedId(), 'platform-id');
    expect(reads, 1);
    expect(values[DeviceIdentityService.selectedIdKey], 'platform-id');
    expect(values[DeviceIdentityService.flutterUdidKey], 'platform-id');
    expect(values[DeviceIdentityService.fallbackUuidKey], 'random-uuid');
    expect(values[DeviceIdentityService.sourceKey], 'flutter_udid');
  });

  test('keeps fallback after FlutterUdid recovers and after restart', () async {
    var available = false;
    Future<String> readUdid() async {
      if (!available) {
        throw StateError('Keychain locked');
      }
      return 'late-platform-id';
    }

    final service = DeviceIdentityService(
      preferences: preferences,
      readUdid: readUdid,
      createFallback: () => 'random-uuid',
    );

    expect(await service.getSelectedId(), 'random-uuid');
    available = true;
    await service.refreshFlutterUdid();

    final restartedService = DeviceIdentityService(
      preferences: preferences,
      readUdid: readUdid,
      createFallback: () => 'different-random-uuid',
    );
    expect(await restartedService.getSelectedId(), 'random-uuid');
    expect(values[DeviceIdentityService.flutterUdidKey], 'late-platform-id');
    expect(values[DeviceIdentityService.fallbackUuidKey], 'random-uuid');
    expect(values[DeviceIdentityService.sourceKey], 'fallback');
  });

  test(
    'later requests save a recovered UDID without rotating the ID',
    () async {
      var available = false;
      final service = DeviceIdentityService(
        preferences: preferences,
        readUdid: () async {
          if (!available) {
            throw StateError('Unavailable');
          }
          return 'late-platform-id';
        },
        createFallback: () => 'random-uuid',
      );

      expect(await service.getSelectedId(), 'random-uuid');
      available = true;
      expect(await service.getSelectedId(), 'random-uuid');
      await pumpEventQueue();
      expect(values[DeviceIdentityService.flutterUdidKey], 'late-platform-id');
      expect(values[DeviceIdentityService.selectedIdKey], 'random-uuid');
    },
  );

  test('concurrent first requests select only one ID', () async {
    var generations = 0;
    final service = DeviceIdentityService(
      preferences: preferences,
      readUdid: () async => throw StateError('Unavailable'),
      createFallback: () => 'random-${++generations}',
    );

    final ids = await Future.wait(<Future<String>>[
      service.getSelectedId(),
      service.getSelectedId(),
      service.getSelectedId(),
    ]);

    expect(ids, everyElement('random-1'));
    expect(generations, 1);
  });

  test('does not return an ID if saving the selected value fails', () async {
    when(
      () => preferences.setString(DeviceIdentityService.selectedIdKey, any()),
    ).thenThrow(StateError('Storage unavailable'));
    final service = DeviceIdentityService(
      preferences: preferences,
      readUdid: () async => 'platform-id',
      createFallback: () => 'random-uuid',
    );

    await expectLater(service.getSelectedId(), throwsStateError);
  });
}
