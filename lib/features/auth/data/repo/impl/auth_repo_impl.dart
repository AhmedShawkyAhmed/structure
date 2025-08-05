import 'package:network_service/network_service.dart';
import 'package:structure/features/auth/data/models/user_model.dart';
import 'package:structure/features/auth/data/repo/interfaces/i_auth_repo.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:structure/features/auth/data/requests/register_request.dart';
import 'package:structure/features/auth/service/auth_web_service.dart';

class AuthRepoImpl implements IAuthRepo {
  final AuthWebService _authWebService;

  AuthRepoImpl(this._authWebService);

  @override
  Future<NetworkResult<NetworkBaseModel>> login({
    required LoginRequest request,
  }) async {
    return executeRequest(() => _authWebService.login(request: request));
  }

  @override
  Future<NetworkResult<NetworkBaseModel<UserModel>>> register({
    required RegisterRequest request,
  }) async {
    return executeRequest(() => _authWebService.register(request: request));
  }
}
