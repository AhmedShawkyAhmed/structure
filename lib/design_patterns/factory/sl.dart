// Factory + GetIt (DI Friendly)

import 'package:core_utils/core_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:structure/design_patterns/factory/auth_repo.dart';

final sl = GetIt.instance;

void setup() {
  sl.registerFactory<IAuthRepo>(() => RemoteAuthRepo());
}

class AuthCubit {
  final IAuthRepo repo;

  AuthCubit(this.repo);

  Future<void> login() async {
    final token = await repo.login('ahmed@test.com', '123456');
    AppLogs.debugLog(token);
  }
}

void main() {
  setup();
  final cubit = AuthCubit(sl<IAuthRepo>());
  cubit.login();
}
