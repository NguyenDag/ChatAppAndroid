import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user_info.dart';

class UserStorage {
  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/users_info.json';
  }

  static Future<List<UserInfo>> readUsersInfo() async {
    final path = await _getFilePath();
    final file = File(path);

    if (!file.existsSync()) return [];

    final content = await file.readAsString();
    final jsonData = json.decode(content);
    return (jsonData as List).map((e) => UserInfo.fromJson(e)).toList();
  }

  static Future<void> saveUserInfo(UserInfo user) async {
    final users = await readUsersInfo();
    users.add(user);

    final path = await _getFilePath();
    final file = File(path);

    final jsonString = json.encode(users.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  static void printAllUsers() async {
    final users = await UserStorage.readUsersInfo();
    for (var user in users) {
      print('👤 ${user.username} - ${user.fullName} - ${user.avatar}');
    }
  }
}