// Factory for Repositories (Clean Architecture Style)

import 'package:core_utils/core_utils.dart';

abstract class IAuthRepo {
  Future<String> login(String email, String password);
}

class RemoteAuthRepo implements IAuthRepo {
  @override
  Future<String> login(String email, String password) async {
    return 'Remote_Token_for_$email';
  }
}

class LocalAuthRepo implements IAuthRepo {
  @override
  Future<String> login(String email, String password) async {
    return 'Local_Token_for_$email';
  }
}

class AuthRepoFactory {
  AuthRepoFactory._();

  static IAuthRepo createRepo({bool offline = false}) {
    if (offline) {
      return LocalAuthRepo();
    }
    return RemoteAuthRepo();
  }
}

void main() async {
  final repo = AuthRepoFactory.createRepo(offline: false);
  final token = await repo.login('test@test.com', '123456');

  AppLogs.debugLog(token);
}
