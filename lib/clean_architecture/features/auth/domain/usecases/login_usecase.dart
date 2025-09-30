import 'package:dartz/dartz.dart';
import 'package:structure/clean_architecture/features/auth/domain/repositories/auth_repositories.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Exception, void>> call(String phone) {
    return repository.login(phone);
  }
}
