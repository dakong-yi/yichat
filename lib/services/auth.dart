import 'dart:convert';
import 'package:http/http.dart';
import 'package:yichat/services/user.dart';

class AuthService {
  Future<bool> login(String username, String password) async {
    final response = await post(
      Uri.parse('http://127.0.0.1:8080/v1/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Charset': 'utf-8',
      },
      body: jsonEncode(<String, String>{
        'email': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      // Login successful
      final userInfo = jsonDecode(response.body);
      UserService.saveUserInfo(userInfo);
      return true;
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    final response = await post(
      Uri.parse('http://127.0.0.1:8080/v1/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': email,
        'device_id': ''
      }),
    );
    if (response.statusCode == 200) {
      return true;
      // Fluttertoast.showToast(msg: 'Registration successful');
      // ignore: use_build_context_synchronously
      // Navigator.pushNamed(context, '/login');
    } else {
      return false;
      // Fluttertoast.showToast(msg: 'Registration fail');
    }
  }
}
