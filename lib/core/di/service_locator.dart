import 'package:get_it/get_it.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/features/auth/cubit/auth_cubit.dart';
import 'package:structure/features/auth/data/repo/impl/auth_repo_impl.dart';
import 'package:structure/features/auth/service/auth_web_service.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
//   // --------------------- Cubit
  serviceLocator.registerFactory<AuthCubit>(() => AuthCubit(serviceLocator()));
//
//   // --------------------- Repo
  serviceLocator.registerLazySingleton<AuthRepoImpl>(() => AuthRepoImpl(serviceLocator()));
//
//   // --------------------- Web Service
  serviceLocator.registerLazySingleton<AuthWebService>(() => AuthWebService(DioFactory.dio));
}