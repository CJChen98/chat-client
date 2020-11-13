import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
    Message();

    String CreatedAt;
    String UpdatedAt;
    String DeletedAt;
    num ID;
    String user_id;
    String username;
    num conversation_id;
    String receiver_id;
    String content;
    String image_url;
    
    factory Message.fromJson(Map<String,dynamic> json) => _$MessageFromJson(json);
    Map<String, dynamic> toJson() => _$MessageToJson(this);
}
