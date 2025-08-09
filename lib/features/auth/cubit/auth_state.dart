import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:network_service/network_service.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState<T> with _$AuthState<T> {
  const factory AuthState.loading() = Loading<T>;

  const factory AuthState.success(T data) = Success<T>;

  const factory AuthState.error(NetworkExceptions error) =
  Error<T>;
}