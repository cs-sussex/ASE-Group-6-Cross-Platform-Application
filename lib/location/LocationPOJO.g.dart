// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationPOJO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationPOJO _$LocationPOJOFromJson(Map<String, dynamic> json) => LocationPOJO(
      json['userId'] as String,
      json['location_name'] as String,
      json['longitude'] as String,
      json['latitude'] as String,
      json['colour'] as String,
    );

Map<String, dynamic> _$LocationPOJOToJson(LocationPOJO instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'location_name': instance.location_name,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'colour': instance.colour,
    };
