import 'package:dartz/dartz.dart';
import 'package:structure/clean_architecture/features/auth/domain/entities/profile_entity.dart';
import 'package:structure/clean_architecture/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:structure/clean_architecture/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, ProfileEntity>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    try {
      final updatedProfile = await remoteDataSource.updateProfile(profile);
      return Right(updatedProfile);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
