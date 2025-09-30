import 'package:dartz/dartz.dart';
import 'package:structure/clean_architecture/features/auth/domain/entities/profile_entity.dart';
import 'package:structure/clean_architecture/features/auth/domain/repositories/auth_repositories.dart';

class ValidateOtpUseCase {
  final AuthRepository authRepository;

  ValidateOtpUseCase(this.authRepository);

  Future<Either<Exception, ProfileEntity>> call(String phone, String otp) async {
    return await authRepository.validateOtp(phone, otp);
  }
}
