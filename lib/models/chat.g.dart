// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return Chat()
    ..code = json['code'] as num
    ..msg = json['msg'] as String
    ..token = json['token'] as String
    ..data = json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'token': instance.token,
      'data': instance.data
    };
