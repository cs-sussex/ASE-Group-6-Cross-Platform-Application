// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginPOJO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginPOJO _$LoginPOJOFromJson(Map<String, dynamic> json) => LoginPOJO(
      json['email'] as String,
      json['password'] as String,
      json['token'] as String,
      json['userID'] as String,
    );

Map<String, dynamic> _$LoginPOJOToJson(LoginPOJO instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'token': instance.token,
      'userID': instance.userID,
    };
