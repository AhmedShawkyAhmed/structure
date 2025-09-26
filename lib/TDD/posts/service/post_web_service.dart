import 'package:network_service/network_service.dart';
import 'package:retrofit/retrofit.dart';
import 'package:structure/TDD/posts/data/models/post_model.dart';
import 'package:structure/core/network/api_routes.dart';

part 'post_web_service.g.dart';

@RestApi()
abstract class PostWebService {
  factory PostWebService(Dio dio, {String baseUrl}) = _PostWebService;

  @GET(APIRoutes.getPosts)
  Future<NetworkBaseModel<List<PostModel>>> getPosts();

  @POST(APIRoutes.addPost)
  Future<NetworkBaseModel<PostModel>> addPost({@Body() required PostModel post});
}
