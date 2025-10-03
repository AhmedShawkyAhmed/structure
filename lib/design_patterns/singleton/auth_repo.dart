// Singleton with Repository Pattern (Matches Your Style)

import 'package:core_utils/core_utils.dart';

abstract class IAuthRepo {
  Future<String> login(String email, String password);
}

class AuthRepo implements IAuthRepo {
  static final AuthRepo _instance = AuthRepo._internal();

  AuthRepo._internal();

  factory AuthRepo() => _instance;

  @override
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Token_for_$email';
  }
}

void main() async {
  final repo1 = AuthRepo();
  final repo2 = AuthRepo();

  AppLogs.debugLog(repo1 == repo2); // true ✅

  final token = await repo1.login('test@test.com', '123456');
  AppLogs.debugLog(token);
}
