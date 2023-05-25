import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:yichat/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
          child: const Text('取消'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/wechat.jpeg',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: '用户名',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                hintText: '请输入用户名',
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(
                color: Colors.black, // 修改为黑色
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '密码',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                hintText: '请输入密码',
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(
                color: Colors.black, // 修改为黑色
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Handle forgot password button press
              },
              child: const Text(
                '忘记密码',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var isLogin = AuthService()
                    .login(_usernameController.text, _passwordController.text);
                if (await isLogin) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  Fluttertoast.showToast(
                    msg: "Login failed",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 25),
                backgroundColor: Colors.green,
                minimumSize: const Size(170, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('登录'),
            ),
          ],
        ),
      ),
    );
  }
}
