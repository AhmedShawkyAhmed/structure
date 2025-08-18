import 'package:network_service/network_service.dart';
import 'package:retrofit/retrofit.dart';
import 'package:structure/core/network/api_routes.dart';
import 'package:structure/features/auth/data/models/user_model.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:structure/features/auth/data/requests/register_request.dart';

part 'auth_web_service.g.dart';

@RestApi()
abstract class AuthWebService {
  factory AuthWebService(Dio dio, {String baseUrl}) = _AuthWebService;

  @POST(APIRoutes.login)
  Future<NetworkBaseModel> login({@Body() required LoginRequest request});

  @POST(APIRoutes.register)
  Future<NetworkBaseModel<UserModel>> register({
    @Body() required RegisterRequest request,
  });
}
