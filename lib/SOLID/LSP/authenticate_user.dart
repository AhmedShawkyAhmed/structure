import 'package:core_utils/core_utils.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/SOLID/OCP/firebase_auth_repo.dart';
import 'package:structure/SOLID/SRP/auth_repo_impl.dart';
import 'package:structure/SOLID/SRP/auth_web_service.dart';
import 'package:structure/SOLID/SRP/i_auth_repo.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';

Future<void> authenticateUser(IAuthRepo repo) async {
  final result = await repo.login(
    request: LoginRequest(email: 'test@test.com', password: '12345678'),
  );
  result.when(
    success: (data) {
      AppLogs.successLog(data.data);
    },
    failure: (error) {
      AppLogs.errorLog(error.networkErrorDetails.message);
    },
  );
}

void main() async {
  // Works with REST repo
  await authenticateUser(AuthRepoImpl(AuthWebService(Dio())));

  // Works with Firebase repo
  await authenticateUser(FirebaseAuthRepo(FirebaseAuth()));
}
