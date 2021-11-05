// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RegistrationPOJO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationPOJO _$RegistrationPOJOFromJson(Map<String, dynamic> json) =>
    RegistrationPOJO(
      json['firstname'] as String,
      json['lastname'] as String,
      json['email'] as String,
      json['password'] as String,
      json['id'] as String,
    );

Map<String, dynamic> _$RegistrationPOJOToJson(RegistrationPOJO instance) =>
    <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'password': instance.password,
      'id': instance.id,
    };
