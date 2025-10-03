// di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/SOLID/OCP/firebase_auth_repo.dart';
import 'package:structure/SOLID/SRP/auth_repo_impl.dart';
import 'package:structure/SOLID/SRP/auth_web_service.dart';

import 'package:structure/SOLID/SRP/i_auth_repo.dart';

final sl = GetIt.instance;

void setup() {
  sl.registerLazySingleton<IAuthRepo>(
    () => AuthRepoImpl(AuthWebService(Dio())),
  );
  // if you want Firebase → just change binding:
  sl.registerLazySingleton<IAuthRepo>(() => FirebaseAuthRepo(FirebaseAuth()));
}
