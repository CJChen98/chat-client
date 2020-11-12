// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return Conversation()
    ..CreatedAt = json['CreatedAt'] as String
    ..UpdatedAt = json['UpdatedAt'] as String
    ..DeletedAt = json['DeletedAt'] as String
    ..ID = json['ID'] as num
    ..private = json['private'] as bool
    ..receiver_id = json['receiver_id'] as num
    ..user_id = json['user_id'] as num;
}

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'CreatedAt': instance.CreatedAt,
      'UpdatedAt': instance.UpdatedAt,
      'DeletedAt': instance.DeletedAt,
      'ID': instance.ID,
      'private': instance.private,
      'receiver_id': instance.receiver_id,
      'user_id': instance.user_id
    };
