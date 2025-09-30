import 'package:dartz/dartz.dart';
import 'package:structure/clean_architecture/features/auth/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Exception, ProfileEntity>> getProfile();
  Future<Either<Exception, ProfileEntity>> updateProfile(ProfileEntity profile);
}