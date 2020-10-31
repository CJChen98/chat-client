import 'package:flutter_web/generated/json/base/json_convert_content.dart';
import 'package:flutter_web/generated/json/base/json_field.dart';

class Entity with JsonConvert<Entity> {
	int code;
	String msg;
	Data data;
}

class Data with JsonConvert<Data> {
	User user;
	List<Message> messages;
}

class User with JsonConvert<User> {
	@JSONField(name: "CreatedAt")
	String createdAt;
	@JSONField(name: "UpdatedAt")
	String updatedAt;
	@JSONField(name: "DeletedAt")
	String deletedAt;
	@JSONField(name: "ID")
	int iD;
	String username;
	String password;
	@JSONField(name: "avatar_path")
	String avatarPath;
}

class Message with JsonConvert<Message> {
	@JSONField(name: "CreatedAt")
	String createdAt;
	@JSONField(name: "UpdatedAt")
	String updatedAt;
	@JSONField(name: "DeletedAt")
	String deletedAt;
	@JSONField(name: "ID")
	int iD;
	@JSONField(name: "user_id")
	int userId;
	@JSONField(name: "to_user_id")
	int toUserId;
	@JSONField(name: "room_id")
	int roomId;
	String content;
	@JSONField(name: "image_url")
	String imageUrl;
}
