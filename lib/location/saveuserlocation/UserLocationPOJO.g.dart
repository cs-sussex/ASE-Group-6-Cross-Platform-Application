// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserLocationPOJO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocationPOJO _$UserLocationPOJOFromJson(Map<String, dynamic> json) =>
    UserLocationPOJO(
      json['userId'] as String,
      json['location_name'] as String,
      (json['longitude'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
      json['colour'] as String,
    );

Map<String, dynamic> _$UserLocationPOJOToJson(UserLocationPOJO instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'location_name': instance.location_name,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'colour': instance.colour,
    };
