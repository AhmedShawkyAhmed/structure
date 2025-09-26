import 'package:flutter_test/flutter_test.dart';
import 'package:structure/TDD/tdd_auth_repo_impl.dart';
import 'package:structure/features/auth/data/models/user_model.dart';

void main() {
  test('login should return success if credentials are valid', () async {
    final repo  = TDDAuthRepoImpl();
    final result = await repo.login(email:'test@test.com', password:'123456');

    expect(result, isA<UserModel>());
  });
}