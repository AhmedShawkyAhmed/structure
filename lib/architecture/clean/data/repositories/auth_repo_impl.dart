import 'package:structure/architecture/clean/data/data_source/auth_remote_data_source.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }
}
