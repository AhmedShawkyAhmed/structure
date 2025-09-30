part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final ProfileEntity profile;

  Authenticated(this.profile);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class LoggedOut extends AuthState {}
