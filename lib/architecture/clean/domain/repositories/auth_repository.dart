import 'package:structure/architecture/clean/domain/entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
}
