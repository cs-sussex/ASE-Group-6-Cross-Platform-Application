import 'package:json_annotation/json_annotation.dart';
part 'RegistrationPOJO.g.dart';


@JsonSerializable()
class RegistrationPOJO
{

   late String firstname;
   late String lastname;
   late String email;
   late String password;
   late String id;

   RegistrationPOJO( this.firstname, this.lastname, this.email, this.password,this.id);
   factory RegistrationPOJO.fromJson(Map<String, dynamic> json) => _$RegistrationPOJOFromJson(json);
   Map<String, dynamic> toJson() => _$RegistrationPOJOToJson(this);



}