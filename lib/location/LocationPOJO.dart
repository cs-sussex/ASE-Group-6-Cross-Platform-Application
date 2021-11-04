import 'package:json_annotation/json_annotation.dart';
part 'LocationPOJO.g.dart';

@JsonSerializable()
class LocationPOJO {
  late String userId;
  late String location_name;
  late String longitude;
  late String latitude;
  late String colour;

  LocationPOJO(this.userId, this.location_name, this.longitude, this.latitude,
      this.colour);
  factory LocationPOJO.fromJson(Map<String, dynamic> json) =>
      _$LocationPOJOFromJson(json);
  Map<String, dynamic> toJson() => _$LocationPOJOToJson(this);
}
