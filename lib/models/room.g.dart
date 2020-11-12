// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) {
  return Room()
    ..id = json['id'] as num
    ..creator_id = json['creator_id'] as num
    ..created_at = json['created_at'] as num
    ..room_name = json['room_name'] as String
    ..member_size = json['member_size'] as num
    ..introduction = json['introduction'] as String
    ..id_ = json['id_'] as String
    ..avatar_path = json['avatar_path'] as String;
}

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'creator_id': instance.creator_id,
      'created_at': instance.created_at,
      'room_name': instance.room_name,
      'member_size': instance.member_size,
      'introduction': instance.introduction,
      'id_': instance.id_,
      'avatar_path': instance.avatar_path
    };
