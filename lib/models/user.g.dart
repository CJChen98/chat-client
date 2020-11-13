// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..username = json['username'] as String
    ..password = json['password'] as String
    ..avatar_path = json['avatar_path'] as String
    ..id = json['id'] as String
    ..created_at = json['created_at'] as String
    ..updated_at = json['updated_at'] as String
    ..deleted_at = json['deleted_at'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'avatar_path': instance.avatar_path,
      'id': instance.id,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'deleted_at': instance.deleted_at
    };
