import 'package:network_service/network_service.dart';
import 'package:structure/TDD/posts/data/models/post_model.dart';

abstract class IPostRepo {
  Future<NetworkResult<NetworkBaseModel<List<PostModel>>>> getPosts();

  Future<NetworkResult<NetworkBaseModel<PostModel>>> addPost({
    required PostModel post,
  });
}
