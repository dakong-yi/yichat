import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserService {
  static Map<String, dynamic> userInfo = {};

  static Future<bool> getLoggedIn() async {
    await getUserInfo();
    return userInfo.isNotEmpty;
  }

  // 存储用户信息
  static Future<void> saveUserInfo(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user);
    await prefs.setString('userInfo', jsonString);
    userInfo = user; // 将用户信息保存到全局变量中
  }

  // 读取用户信息
  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('userInfo');
    if (jsonString != null) {
      userInfo = jsonDecode(jsonString);
      return userInfo;
    } else {
      return {};
    }
  }

  // 清除用户信息
  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userInfo');
  }
}
