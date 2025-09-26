import 'package:network_service/network_service.dart';
import 'package:structure/TDD/posts/data/models/post_model.dart';
import 'package:structure/TDD/posts/data/repo/interface/i_post_repo.dart';
import 'package:structure/TDD/posts/service/post_web_service.dart';

class PostRepoImpl extends IPostRepo {
  final PostWebService _postWebService;
  PostRepoImpl(this._postWebService);
  @override
  Future<NetworkResult<NetworkBaseModel<List<PostModel>>>> getPosts() async{
    return executeRequest(() => _postWebService.getPosts());
  }

  @override
  Future<NetworkResult<NetworkBaseModel<PostModel>>> addPost({
    required PostModel post,
  }) {
    return executeRequest(() => _postWebService.addPost(post: post));
  }
}
