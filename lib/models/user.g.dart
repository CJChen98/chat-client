// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..CreatedAt = json['CreatedAt'] as String
    ..UpdatedAt = json['UpdatedAt'] as String
    ..DeletedAt = json['DeletedAt'] as String
    ..ID = json['ID'] as num
    ..username = json['username'] as String
    ..password = json['password'] as String
    ..avatar_path = json['avatar_path'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'CreatedAt': instance.CreatedAt,
      'UpdatedAt': instance.UpdatedAt,
      'DeletedAt': instance.DeletedAt,
      'ID': instance.ID,
      'username': instance.username,
      'password': instance.password,
      'avatar_path': instance.avatar_path
    };
