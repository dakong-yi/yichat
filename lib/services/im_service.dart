import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:yichat/services/user.dart';

class IMService {
  static IMService? _instance;
  late Socket _socket;

  factory IMService() {
    return _instance ??= IMService._();
  }

  IMService._();

  void Function(String message)? onMessageReceived;

  Future<void> connect(String host, int port) async {
    // 创建TCP连接
    _socket = await Socket.connect(host, port);
    Login();
    // 监听消息
    _socket.listen((List<int> data) {
      var message = String.fromCharCodes(data);
      print('接收到消息：$message');
      if (onMessageReceived != null) {
        Map<String, dynamic> msg = jsonDecode(message);
        onMessageReceived!(msg['data']);
      }
    });
  }

  void _handleMessageReceived(List<int> data) {
    var message = String.fromCharCodes(data);
    print('接收到消息：$message');
    if (onMessageReceived != null) {
      onMessageReceived!(message);
    }
  }

  void send(String message) {
    _socket.write(message);
  }

  void Login() {
    var userinfo = UserService.userInfo;
    Map<String, dynamic> req = {
      'request_id': 123,
      'data': jsonEncode(userinfo),
      'type': 0,
    };
    _socket.write(jsonEncode(req));
  }

  void SendMsg(String recipient, String content) {
    var userinfo = UserService.userInfo;
    Map<String, dynamic> data = {
      'Sender': userinfo['userId'],
      'Recipient': recipient,
      'Content': content,
    };
    Map<String, dynamic> req = {
      'request_id': 123,
      'data': jsonEncode(data),
      'type': 2,
    };
    _socket.write(jsonEncode(req));
  }

  void close() {
    _socket.close();
  }

  void startHeartbeat() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_socket == null) {
        // connect();
      } else {
        _socket.write('ping');
      }
    });
  }
}
