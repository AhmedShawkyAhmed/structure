import 'package:dartz/dartz.dart';
import 'package:structure/clean_architecture/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:structure/clean_architecture/features/auth/domain/entities/profile_entity.dart';
import 'package:structure/clean_architecture/features/auth/domain/repositories/auth_repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, void>> login(String phone) async {
    try {
      await remoteDataSource.login(phone);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, ProfileEntity>> validateOtp(
    String phone,
    String otp,
  ) async {
    try {
      final profile = await remoteDataSource.validateOtp(phone, otp);
      return Right(profile);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
