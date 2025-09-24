import 'package:flutter_test/flutter_test.dart';
import 'package:hive_service/hive_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/features/auth/data/repo/impl/auth_repo_impl.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:structure/features/auth/service/auth_web_service.dart';

// ----------------- Mocks -----------------
class MockAuthWebService extends Mock implements AuthWebService {}

class MockHiveService extends Mock implements HiveService {}

void main() {
  late MockAuthWebService mockWeb;
  late MockHiveService mockHive;
  late AuthRepoImpl repo;

  setUp(() {
    mockWeb = MockAuthWebService();
    mockHive = MockHiveService();
    repo = AuthRepoImpl(mockWeb, mockHive);
  });

  group('AuthRepoImpl.login', () {
    test('returns success when webService returns success', () async {
      // arrange
      final request = LoginRequest(email: 'test@test.com', password: '123456');
      final fakeResponse = NetworkBaseModel<dynamic>(data: 'ok');

      when(
        () => mockWeb.login(request: request),
      ).thenAnswer((_) async => fakeResponse);

      // act
      final result = await repo.login(request: request);

      // assert
      expect(result, isA<NetworkResult<NetworkBaseModel>>());
      result.when(
        success: (res) => expect(res.data, 'ok'),
        failure: (_) => fail('Should not fail'),
      );

      verify(() => mockWeb.login(request: request)).called(1);
    });

    test('returns failure when webService throws DioException', () async {
      // arrange
      final request = LoginRequest(email: 'test@test.com', password: 'wrong');

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/login'),
        type: DioExceptionType.cancel,
      );

      when(() => mockWeb.login(request: request)).thenThrow(dioError);

      // act
      final result = await repo.login(request: request);

      result.when(
        success: (_) => fail('Expected failure'),
        failure: (err) {
          expect(err, isA<NetworkExceptions>());
          err.maybeWhen(
            requestCancelled: (details) {
              expect(details, isA<NetworkErrorDetails>());
            },
            orElse: () => fail('Expected requestCancelled'),
          );
        },
      );

      verify(() => mockWeb.login(request: request)).called(1);
    });
  });
}
