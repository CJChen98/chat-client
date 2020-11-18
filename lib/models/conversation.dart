import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation {
  int count = 0;

  String title = "";

  String preview = "";

  String avatar="";

  Conversation();

  String CreatedAt;
  String UpdatedAt;
  String DeletedAt;
  num ID;
  bool private;
  String receiver_id;
  String user_id;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
