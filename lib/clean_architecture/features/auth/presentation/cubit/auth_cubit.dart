import 'package:bloc/bloc.dart';
import 'package:structure/clean_architecture/features/auth/domain/entities/profile_entity.dart';
import 'package:structure/clean_architecture/features/auth/domain/usecases/login_usecase.dart';
import 'package:structure/clean_architecture/features/auth/domain/usecases/logout_usecase.dart';
import 'package:structure/clean_architecture/features/auth/domain/usecases/validate_otp_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final ValidateOtpUseCase validateOtpUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.validateOtpUseCase,
  }) : super(AuthInitial());

  void login(String phone) async {
    emit(AuthLoading());
    final result = await loginUseCase(phone);
    result.fold(
      (error) => emit(AuthError(error.toString())),
      (_) => emit(AuthInitial()),
    );
  }

  void validateOtp(String phone, String otp) async {
    emit(AuthLoading());
    final result = await validateOtpUseCase(phone, otp);
    result.fold(
      (error) => emit(AuthError(error.toString())),
      (profile) => emit(Authenticated(profile)),
    );
  }

  void logout() async {
    emit(AuthLoading());
    final result = await logoutUseCase();
    result.fold(
      (error) => emit(AuthError(error.toString())),
      (_) => emit(LoggedOut()),
    );
  }
}
