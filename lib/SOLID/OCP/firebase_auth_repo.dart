import 'package:network_service/network_service.dart';
import 'package:structure/SOLID/SRP/i_auth_repo.dart';
import 'package:structure/features/auth/data/models/user_model.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:structure/features/auth/data/requests/register_request.dart';

class FirebaseAuthRepo implements IAuthRepo {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepo(this._firebaseAuth);

  @override
  Future<NetworkResult<NetworkBaseModel>> login({
    required LoginRequest request,
  }) async {
    return await executeRequest(
      () => _firebaseAuth.signInWithEmailAndPassword(request: request),
    );
  }

  @override
  Future<NetworkResult<NetworkBaseModel<UserModel>>> register({
    required RegisterRequest request,
  }) async {
    return await executeRequest(
      () => _firebaseAuth.createUserWithEmailAndPassword(request: request),
    );
  }
}

class FirebaseAuth {
  Future<NetworkBaseModel> signInWithEmailAndPassword({
    required LoginRequest request,
  }) async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
    return NetworkBaseModel(message: 'Login successful');
  }

  Future<NetworkBaseModel<UserModel>> createUserWithEmailAndPassword({
    required RegisterRequest request,
  }) async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
    return NetworkBaseModel<UserModel>(
      data: UserModel(id: 1, email: request.email),
      message: 'Registration successful',
    );
  }
}
