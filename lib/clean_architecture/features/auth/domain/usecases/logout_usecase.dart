import 'package:dartz/dartz.dart';
import 'package:structure/clean_architecture/features/auth/domain/repositories/auth_repositories.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Exception, void>> call() async {
    return repository.logout();
  }
}
