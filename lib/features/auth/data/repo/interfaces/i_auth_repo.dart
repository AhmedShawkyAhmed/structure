import 'package:network_service/network_service.dart';
import 'package:structure/features/auth/data/models/user_model.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:structure/features/auth/data/requests/register_request.dart';

abstract class IAuthRepo {
  Future<NetworkResult<NetworkBaseModel>> login({
    required LoginRequest request,
  });

  Future<NetworkResult<NetworkBaseModel<UserModel>>> register({
    required RegisterRequest request,
  });
}
