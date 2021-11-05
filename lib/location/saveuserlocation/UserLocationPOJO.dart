
import 'package:json_annotation/json_annotation.dart';
part 'UserLocationPOJO.g.dart';


@JsonSerializable()
class UserLocationPOJO
{


late  String userId;
late   String location_name;
late  double longitude;
 late  double latitude;
  late String colour;

  UserLocationPOJO(this.userId,this.location_name,this.longitude,this.latitude,this.colour);

factory UserLocationPOJO.fromJson(Map<String, dynamic> json) => _$UserLocationPOJOFromJson(json);
Map<String, dynamic> toJson() => _$UserLocationPOJOToJson(this);

}