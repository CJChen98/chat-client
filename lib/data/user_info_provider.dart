import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/user.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoProvider with ChangeNotifier {
  User _user = User();

  var _appConfig = GetIt.instance<AppConfig>();

  get user => _user;

  set(User user, {String token}) async {
    user.avatar_path = _appConfig.apiHost + user.avatar_path;
    if (token != null) {
      await _saveUserInfo("token", token);
      _appConfig.token = token;
    }
    await _saveUserInfo("avatar", user.avatar_path);
    await _saveUserInfo("id", user.id.toString());
    await _saveUserInfo("username", user.username);
    _appConfig
      ..username = user.username
      ..currentUserID = user.id
      ..avatar = user.avatar_path;
    _user = user;
    notifyListeners();
  }

  getInfo() async {
    final spf = await SharedPreferences.getInstance();
    final avatar = spf.getString("avatar");
    final username = spf.getString("username");
    final userID = spf.getString("id");
    _user = User()
      ..avatar_path = avatar
      ..username = username
      ..id = userID;
    notifyListeners();
  }

  _saveUserInfo(String key, String value) async {
    var spf = await SharedPreferences.getInstance();
    spf.setString(key, value).then((result) =>
    {
      if (result) {debugPrint("$key 保存成功")} else
        {debugPrint("$key 保存失败")}
    });
  }
}
