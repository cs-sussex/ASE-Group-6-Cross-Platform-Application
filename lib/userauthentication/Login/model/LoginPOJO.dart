import 'package:json_annotation/json_annotation.dart';
part 'LoginPOJO.g.dart';


@JsonSerializable()
class LoginPOJO
{
  late String email;
  late String password;
  late String token;
  late String userID;

  LoginPOJO( this.email, this.password, this.token,this.userID);
  factory LoginPOJO.fromJson(Map<String, dynamic> json) => _$LoginPOJOFromJson(json);
  Map<String, dynamic> toJson() => _$LoginPOJOToJson(this);

}