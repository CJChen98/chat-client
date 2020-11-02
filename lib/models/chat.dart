import 'package:json_annotation/json_annotation.dart';
import "data.dart";
part 'chat.g.dart';

@JsonSerializable()
class Chat {
    Chat();

    num code;
    String msg;
    String token;
    Data data;
    
    factory Chat.fromJson(Map<String,dynamic> json) => _$ChatFromJson(json);
    Map<String, dynamic> toJson() => _$ChatToJson(this);
}
