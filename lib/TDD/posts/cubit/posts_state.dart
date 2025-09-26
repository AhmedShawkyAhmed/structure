import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:network_service/network_service.dart';

part 'posts_state.freezed.dart';

@freezed
class PostsState<T> with _$PostsState<T> {
  const factory PostsState.initial() = _Initial;
  const factory PostsState.loading() = Loading<T>;

  const factory PostsState.success(T data) = Success<T>;

  const factory PostsState.error(NetworkExceptions error) = Error<T>;
}
