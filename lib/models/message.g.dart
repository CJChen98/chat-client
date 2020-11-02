// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message()
    ..CreatedAt = json['CreatedAt'] as String
    ..UpdatedAt = json['UpdatedAt'] as String
    ..DeletedAt = json['DeletedAt'] as String
    ..ID = json['ID'] as num
    ..user_id = json['user_id'] as num
    ..username = json['username'] as String
    ..to_user_id = json['to_user_id'] as num
    ..room_id = json['room_id'] as num
    ..content = json['content'] as String
    ..image_url = json['image_url'] as String;
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'CreatedAt': instance.CreatedAt,
      'UpdatedAt': instance.UpdatedAt,
      'DeletedAt': instance.DeletedAt,
      'ID': instance.ID,
      'user_id': instance.user_id,
      'username': instance.username,
      'to_user_id': instance.to_user_id,
      'room_id': instance.room_id,
      'content': instance.content,
      'image_url': instance.image_url
    };
