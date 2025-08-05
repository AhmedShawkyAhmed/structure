import 'package:bloc/bloc.dart';
import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/features/auth/data/repo/impl/auth_repo_impl.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:structure/features/auth/data/requests/register_request.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());
  AuthRepoImpl authRepo;

  Future login({required LoginRequest request}) async {
    emit(LoginLoading());
    final result = await authRepo.login(request: request);

    result.handle(
      onSuccess: (data) {
        AppLogs.responseLog(data);
        emit(LoginSuccess());
      },
      onFailure: (error) {
        AppLogs.errorLog(error);
        emit(LoginFailure());
      },
    );
  }

  Future register({required RegisterRequest request}) async {
    emit(RegisterLoading());
    final result = await authRepo.register(request: request);

    result.handle(
      onSuccess: (data) {
        AppLogs.responseLog(data);
        emit(RegisterSuccess());
      },
      onFailure: (error) {
        AppLogs.errorLog(error);
        emit(RegisterFailure());
      },
    );
  }
}
