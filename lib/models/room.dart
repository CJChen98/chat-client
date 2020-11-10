import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
    Room();

    num id;
    num creator_id;
    String room_name;
    num member_size;
    String introduction;
    String id_;
    
    factory Room.fromJson(Map<String,dynamic> json) => _$RoomFromJson(json);
    Map<String, dynamic> toJson() => _$RoomToJson(this);
}
