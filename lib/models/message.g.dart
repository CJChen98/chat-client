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
    ..user_id = json['user_id'] as String
    ..username = json['username'] as String
    ..conversation_id = json['conversation_id'] as num
    ..receiver_id = json['receiver_id'] as String
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
      'conversation_id': instance.conversation_id,
      'receiver_id': instance.receiver_id,
      'content': instance.content,
      'image_url': instance.image_url
    };
