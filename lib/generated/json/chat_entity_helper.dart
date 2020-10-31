import 'package:flutter_web/model/entity.dart';

entityFromJson(Entity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	if (json['msg'] != null) {
		data.msg = json['msg']?.toString();
	}
	if (json['data'] != null) {
		data.data = new Data().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> entityToJson(Entity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['msg'] = entity.msg;
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	return data;
}

dataFromJson(Data data, Map<String, dynamic> json) {
	if (json['user'] != null) {
		data.user = new User().fromJson(json['user']);
	}
	if (json['messages'] != null) {
		data.messages = new List<Message>();
		(json['messages'] as List).forEach((v) {
			data.messages.add(new Message().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> dataToJson(Data entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.user != null) {
		data['user'] = entity.user.toJson();
	}
	if (entity.messages != null) {
		data['messages'] =  entity.messages.map((v) => v.toJson()).toList();
	}
	return data;
}

userFromJson(User data, Map<String, dynamic> json) {
	if (json['CreatedAt'] != null) {
		data.createdAt = json['CreatedAt']?.toString();
	}
	if (json['UpdatedAt'] != null) {
		data.updatedAt = json['UpdatedAt']?.toString();
	}
	if (json['DeletedAt'] != null) {
		data.deletedAt = json['DeletedAt']?.toString();
	}
	if (json['ID'] != null) {
		data.iD = json['ID']?.toInt();
	}
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['password'] != null) {
		data.password = json['password']?.toString();
	}
	if (json['avatar_path'] != null) {
		data.avatarPath = json['avatar_path']?.toString();
	}
	return data;
}

Map<String, dynamic> userToJson(User entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['CreatedAt'] = entity.createdAt;
	data['UpdatedAt'] = entity.updatedAt;
	data['DeletedAt'] = entity.deletedAt;
	data['ID'] = entity.iD;
	data['username'] = entity.username;
	data['password'] = entity.password;
	data['avatar_path'] = entity.avatarPath;
	return data;
}

messageFromJson(Message data, Map<String, dynamic> json) {
	if (json['CreatedAt'] != null) {
		data.createdAt = json['CreatedAt']?.toString();
	}
	if (json['UpdatedAt'] != null) {
		data.updatedAt = json['UpdatedAt']?.toString();
	}
	if (json['DeletedAt'] != null) {
		data.deletedAt = json['DeletedAt']?.toString();
	}
	if (json['ID'] != null) {
		data.iD = json['ID']?.toInt();
	}
	if (json['user_id'] != null) {
		data.userId = json['user_id']?.toInt();
	}
	if (json['to_user_id'] != null) {
		data.toUserId = json['to_user_id']?.toInt();
	}
	if (json['room_id'] != null) {
		data.roomId = json['room_id']?.toInt();
	}
	if (json['content'] != null) {
		data.content = json['content']?.toString();
	}
	if (json['image_url'] != null) {
		data.imageUrl = json['image_url']?.toString();
	}
	return data;
}

Map<String, dynamic> messageToJson(Message entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['CreatedAt'] = entity.createdAt;
	data['UpdatedAt'] = entity.updatedAt;
	data['DeletedAt'] = entity.deletedAt;
	data['ID'] = entity.iD;
	data['user_id'] = entity.userId;
	data['to_user_id'] = entity.toUserId;
	data['room_id'] = entity.roomId;
	data['content'] = entity.content;
	data['image_url'] = entity.imageUrl;
	return data;
}