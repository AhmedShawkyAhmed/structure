import 'package:dartz/dartz.dart';
import 'package:structure/clean_architecture/features/auth/domain/entities/profile_entity.dart';

abstract class AuthRepository {
  Future<Either<Exception, void>> login(String phone);
  Future<Either<Exception, ProfileEntity>> validateOtp(String phone, String otp);
  Future<Either<Exception, void>> logout();
}