import 'package:structure/features/auth/data/models/user_model.dart';

class TDDAuthRepoImpl{
  Future<UserModel> login({required String email, required String password}) async {
    if(email == 'test@test.com' && password == '123456'){
      return UserModel(firstName: 'Ahmed', lastName: 'Shawky', email: email);
    }else {
      throw Exception('Invalid credentials');
    }
  }
}