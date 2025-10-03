// cubit/auth_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';

import '../SRP/i_auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepo authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepo.login(
      request: LoginRequest(email: email, password: password),
    );
    result.when(
      success: (data) {
        emit(AuthSuccess());
      },
      failure: (error) {
        emit(AuthError());
      },
    );
  }
}
