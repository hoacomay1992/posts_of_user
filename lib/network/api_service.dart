import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:posts_of_user/network/model/posts_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://5fb3515cb6601200168f73f8.mockapi.io/hoacomay/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return ApiService(dio);
  }

  @GET("Posts")
  Future<List<PostsModel>> getPosts();

  @POST("Posts")
  Future<PostsModel> insertPosts(@Body() PostsModel postsModel);
}
