import 'package:json_annotation/json_annotation.dart';
part 'GetAllLocationPOJO.g.dart';


@JsonSerializable()
class GetAllLocationPOJO {

  late String id;
  late User user;
  late String location_name;
  late double longitude;
  late double latitude;
  late String colour;

  GetAllLocationPOJO(this.id,this.user,this.location_name,this.longitude,this.latitude,this.colour);
  factory GetAllLocationPOJO.fromJson(Map<String, dynamic> json) => _$GetAllLocationPOJOFromJson(json);
  Map<String, dynamic> toJson() => _$GetAllLocationPOJOToJson(this);


}
@JsonSerializable()
  class User{
 late String id;
 late  String firstname;
 late  String lastname;
 late  String dateCreated;
 late  String dateUpdated;
  late String email;
 late  String password;
 User(this.id,this.firstname,this.lastname,this.dateCreated,this.dateUpdated,this.email,this.password);
 factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
 Map<String, dynamic> toJson() => _$UserToJson(this);
  }


