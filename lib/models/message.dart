import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
    Message();

    String CreatedAt;
    String UpdatedAt;
    String DeletedAt;
    num ID;
    num user_id;
    String username;
    num to_user_id;
    num room_id;
    String content;
    String image_url;
    
    factory Message.fromJson(Map<String,dynamic> json) => _$MessageFromJson(json);
    Map<String, dynamic> toJson() => _$MessageToJson(this);
}
