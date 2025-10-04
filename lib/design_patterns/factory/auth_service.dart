import 'package:core_utils/core_utils.dart';
// Simple Factory (Creating Different Auth Types)

abstract class IAuthService {
  void login(String email, String password);
}

class FirebaseAuthService implements IAuthService {
  @override
  void login(String email, String password) {
    AppLogs.debugLog('Login using FirebaseAuth: $email');
  }
}

class ApiAuthService implements IAuthService {
  @override
  void login(String email, String password) {
    AppLogs.debugLog('Login using API backend: $email');
  }
}

/// Factory
class AuthServiceFactory {
  AuthServiceFactory._();

  static IAuthService createAuthService(String type) {
    if (type == 'firebase') {
      return FirebaseAuthService();
    } else {
      return ApiAuthService();
    }
  }
}

void main() {
  final auth = AuthServiceFactory.createAuthService('api');
  auth.login('test@test.com', '123456');
}
