import 'dart:async';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'test@test.com' && password == '1234') {
      return UserModel(email: email, token: 'fake_jwt_token', name: 'Test');
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
