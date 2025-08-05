import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
//   // --------------------- Cubit
//   instance.registerFactory<AuthCubit>(() => AuthCubit(instance()));
//
//   // --------------------- Repo
//   instance.registerLazySingleton<AuthRepo>(() => AuthRepo(instance()));
//
//   // --------------------- Web Service
//   instance.registerLazySingleton<AuthWebService>(() => AuthWebService(DioFactory.dio));
}