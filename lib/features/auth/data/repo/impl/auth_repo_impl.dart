import 'package:hive_service/hive_service.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/core/caching/cache_keys.dart';
import 'package:structure/features/auth/data/models/user_model.dart';
import 'package:structure/features/auth/data/repo/interfaces/i_auth_repo.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:structure/features/auth/data/requests/register_request.dart';
import 'package:structure/features/auth/service/auth_web_service.dart';

class AuthRepoImpl implements IAuthRepo {
  final AuthWebService _authWebService;
  final HiveService _hiveService;

  AuthRepoImpl(this._authWebService, this._hiveService);

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
    final result = await executeRequest(
      () => _authWebService.register(request: request),
    );

    result.when(
      success: (response) {
        _hiveService.putItem(
          boxName: CacheBoxName.appBox,
          key: CacheKeys.fcmToken,
          item: response.data?.token,
        );
      },
      failure: (_) {},
    );

    return result;
  }

  String? getToken() {
    return _hiveService.getItem(
      boxName: CacheBoxName.appBox,
      key: CacheKeys.fcmToken,
    );
  }

  Future<void> clearToken() async {
    await _hiveService.deleteItem(
      boxName: CacheBoxName.appBox,
      key: CacheKeys.fcmToken,
    );
  }
}
