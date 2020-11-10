import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation {
    Conversation();

    num ID;
    bool private;
    num receiver_id;
    num user_id;
    
    factory Conversation.fromJson(Map<String,dynamic> json) => _$ConversationFromJson(json);
    Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
