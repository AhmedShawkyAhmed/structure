import 'package:bloc/bloc.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/TDD/cubit/posts_state.dart';
import 'package:structure/TDD/data/models/post_model.dart';
import 'package:structure/TDD/data/repo/interface/i_post_repo.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this.postRepo) : super(const PostsState.initial());
  IPostRepo postRepo;

  Future getPosts() async {
    emit(const PostsState.loading());
    final result = await postRepo.getPosts();

    result.handle(
      onSuccess: (data) {
        emit(PostsState<List<PostModel>>.success(data));
      },
      onFailure: (error) {
        emit(PostsState.error(error));
      },
    );
  }

  Future addPost({required PostModel post}) async {
    emit(const PostsState.loading());
    final result = await postRepo.addPost(post: post);

    result.handle(
      onSuccess: (data) {
        emit(PostsState<PostModel>.success(data));
      },
      onFailure: (error) {
        emit(PostsState.error(error));
      },
    );
  }
}
