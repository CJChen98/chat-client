import 'package:json_annotation/json_annotation.dart';
import "user.dart";
import "message.dart";
part 'data.g.dart';

@JsonSerializable()
class Data {
    Data();

    User user;
    List<Message> messages;
    List<User> users;
    
    factory Data.fromJson(Map<String,dynamic> json) => _$DataFromJson(json);
    Map<String, dynamic> toJson() => _$DataToJson(this);
}
