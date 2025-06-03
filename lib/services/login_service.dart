import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static Future<bool> isLoggedInWithinAWeek() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final loginTimeStr = prefs.getString('login_time');

    if (token == null || loginTimeStr == null) return false;

    final loginTime = DateTime.parse(loginTimeStr);
    final now = DateTime.now();
    final diff = now.difference(loginTime);

    return diff.inDays <= 7;
  }
}