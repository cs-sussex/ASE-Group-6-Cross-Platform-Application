// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetAllLocationPOJO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllLocationPOJO _$GetAllLocationPOJOFromJson(Map<String, dynamic> json) =>
    GetAllLocationPOJO(
      json['id'] as String,
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['location_name'] as String,
      (json['longitude'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
      json['colour'] as String,
    );

Map<String, dynamic> _$GetAllLocationPOJOToJson(GetAllLocationPOJO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'location_name': instance.location_name,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'colour': instance.colour,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as String,
      json['firstname'] as String,
      json['lastname'] as String,
      json['dateCreated'] as String,
      json['dateUpdated'] as String,
      json['email'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'dateCreated': instance.dateCreated,
      'dateUpdated': instance.dateUpdated,
      'email': instance.email,
      'password': instance.password,
    };
