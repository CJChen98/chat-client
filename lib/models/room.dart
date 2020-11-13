import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
    Room();

    String creator_id;
    num created_at;
    String room_name;
    num member_size;
    String introduction;
    String id;
    String avatar_path;
    
    factory Room.fromJson(Map<String,dynamic> json) => _$RoomFromJson(json);
    Map<String, dynamic> toJson() => _$RoomToJson(this);
}
