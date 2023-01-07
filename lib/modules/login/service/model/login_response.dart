import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {

	factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
	Map<String, dynamic> toJson( instance) => _$LoginResponseToJson(this);

  String? name;
  String? email;
  String? bearer;

  LoginResponse({this.name, this.email, this.bearer});


}