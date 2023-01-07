import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:template_app/modules/login/constant.dart';
import 'package:template_app/modules/login/service/model/login_response.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: kLoginBaseUrl)
abstract class AuthService {

  factory AuthService(Dio dio, {String? baseUrl}) = _AuthService;
  
  @POST("what")
  @FormUrlEncoded()
  Future<LoginResponse> login({
    @Field() String? email,
    @Field() String? pass
  });

  @GET("what")
  Future<LoginResponse> logout();
}

