import 'package:get_it/get_it.dart';
import 'package:hive_service/hive_service.dart';
import 'package:structure/TDD/posts/cubit/posts_cubit.dart';
import 'package:structure/TDD/posts/data/repo/impl/post_repo_impl.dart';
import 'package:structure/TDD/posts/data/repo/interface/i_post_repo.dart';
import 'package:structure/TDD/posts/service/post_web_service.dart';
import 'package:structure/core/network/custom_dio_factory.dart';
import 'package:structure/features/auth/cubit/auth_cubit.dart';
import 'package:structure/features/auth/data/repo/impl/auth_repo_impl.dart';
import 'package:structure/features/auth/data/repo/interfaces/i_auth_repo.dart';
import 'package:structure/features/auth/service/auth_web_service.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // --------------------- Services
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());

  // --------------------- Web Service
  serviceLocator.registerLazySingleton<AuthWebService>(
    () => AuthWebService(CustomDioFactory.dio),
  );
  serviceLocator.registerLazySingleton<PostWebService>(
    () => PostWebService(CustomDioFactory.dio),
  );

  // --------------------- Repo (bind inheritance to implementation)
  serviceLocator.registerLazySingleton<IAuthRepo>(
    () => AuthRepoImpl(
      serviceLocator<AuthWebService>(),
      serviceLocator<HiveService>(),
    ),
  );
  serviceLocator.registerLazySingleton<IPostRepo>(
    () => PostRepoImpl(serviceLocator<PostWebService>()),
  );

  // --------------------- Cubit (depends on inheritance)
  serviceLocator.registerFactory<AuthCubit>(
    () => AuthCubit(serviceLocator<IAuthRepo>()),
  );
  serviceLocator.registerFactory<PostsCubit>(
    () => PostsCubit(serviceLocator<IPostRepo>()),
  );
}
