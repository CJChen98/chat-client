import 'package:json_annotation/json_annotation.dart';
import "user.dart";
import "message.dart";
import "conversation.dart";
import "room.dart";
part 'data.g.dart';

@JsonSerializable()
class Data {
    Data();

    User user;
    List<Message> messages;
    List<User> users;
    List<Conversation> conversations;
    List<Room> rooms;
    
    factory Data.fromJson(Map<String,dynamic> json) => _$DataFromJson(json);
    Map<String, dynamic> toJson() => _$DataToJson(this);
}
