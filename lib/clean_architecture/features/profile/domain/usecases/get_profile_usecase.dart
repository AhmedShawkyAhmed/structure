import 'package:dartz/dartz.dart';
import 'package:structure/clean_architecture/features/auth/domain/entities/profile_entity.dart';
import 'package:structure/clean_architecture/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Exception, ProfileEntity>> call() {
    return repository.getProfile();
  }
}
