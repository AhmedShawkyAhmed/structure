import 'package:structure/features/auth/data/models/user_model.dart';

// Bad Example
abstract class IUserRepo {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<void> updateProfile(UserModel user);
  Future<void> deleteAccount();
}



// Good Example for ISP (Interface Segregation Principle)
abstract class IAuthRepo {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
}

abstract class IProfileRepo {
  Future<void> updateProfile(UserModel user);
}

abstract class IAccountRepo {
  Future<void> deleteAccount();
}
