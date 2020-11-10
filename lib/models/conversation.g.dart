// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return Conversation()
    ..ID = json['ID'] as num
    ..private = json['private'] as bool
    ..receiver_id = json['receiver_id'] as num
    ..user_id = json['user_id'] as num;
}

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'private': instance.private,
      'receiver_id': instance.receiver_id,
      'user_id': instance.user_id
    };
