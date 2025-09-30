import 'package:structure/clean_architecture/features/auth/domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile();

  Future<ProfileEntity> updateProfile(ProfileEntity profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileEntity> getProfile() async {
    await Future.delayed(const Duration(seconds: 2));
    return ProfileEntity(
      id: '1',
      name: 'John Doe',
      phone: '1234567890',
      email: 'john.doe@gmail.com',
      token: 'token123',
    );
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    await Future.delayed(const Duration(seconds: 2));
    return profile;
  }
}
