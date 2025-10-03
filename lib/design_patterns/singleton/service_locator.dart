import 'package:core_utils/core_utils.dart';
import 'package:get_it/get_it.dart';

// Lazy Singleton with GetIt Service Locator

final serviceLocator = GetIt.instance;

class AuthService {
  void login(String email, String password) {
    AppLogs.debugLog('Logging in: $email');
  }
}

void setupLocator() {
  // Register as Lazy Singleton
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
}

void main() {
  setupLocator();

  final auth = serviceLocator<AuthService>();
  auth.login('test@test.com', '123456');
}
