import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
    User();

    String CreatedAt;
    String UpdatedAt;
    String DeletedAt;
    num ID;
    String username;
    String password;
    String avatar_path;
    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}
