import 'package:core_utils/core_utils.dart';
import 'package:structure/clean_architecture/features/auth/data/models/profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String phone);

  Future<ProfileModel> validateOtp(String phone, String otp);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<void> login(String phone) async {
    await Future.delayed(const Duration(seconds: 2));
    AppLogs.debugLog('OTP: 1234');
  }

  @override
  Future<ProfileModel> validateOtp(String phone, String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    if (otp == '1234') {
      return ProfileModel(
        id: '1',
        name: 'John Doe',
        phone: phone,
        email: 'john.doe@fmail.com',
        token: 'token1234',
      );
    } else {
      throw Exception('Invalid OTP');
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 2));
    AppLogs.debugLog('Logged out successfully');
  }
}
