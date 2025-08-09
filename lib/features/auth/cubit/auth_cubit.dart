import 'package:bloc/bloc.dart';
import 'package:core_utils/core_utils.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/features/auth/data/repo/impl/auth_repo_impl.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:structure/features/auth/data/requests/register_request.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(const AuthState.loading());
  AuthRepoImpl authRepo;

  Future login({required LoginRequest request}) async {
    emit(const AuthState.loading());
    final result = await authRepo.login(request: request);

    result.handle(
      onSuccess: (data) {
        AppLogs.responseLog(data);
        emit(AuthState.success(data));
      },
      onFailure: (error) {
        AppLogs.errorLog(error);
        emit(AuthState.error(error));
      },
    );
  }

  Future register({required RegisterRequest request}) async {
    emit(const AuthState.loading());
    final result = await authRepo.register(request: request);

    result.handle(
      onSuccess: (data) {
        AppLogs.responseLog(data);
        emit(AuthState.success(data));
      },
      onFailure: (error) {
        AppLogs.errorLog(error);
        emit(AuthState.error(error));
      },
    );
  }
}
