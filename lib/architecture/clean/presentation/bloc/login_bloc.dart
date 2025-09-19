import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/architecture/clean/domain/entities/user.dart';
import 'package:structure/architecture/clean/domain/usecases/login_usecase.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await loginUseCase(event.email, event.password);
        emit(LoginSuccess(user));
      } catch (e) {
        emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
      }
    });
  }
}
