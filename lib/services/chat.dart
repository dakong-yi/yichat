import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';

import 'user.dart';
import 'package:yichat/models/message.dart';
import 'package:yichat/models/chat.dart';

class ChatService {
  static Future<void> saveChatMessage(
      String userId, String friendId, List<ChatMessage> chatList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> chatListMap =
        chatList.map((chat) => chat.toJson()).toList();
    String chatListString = jsonEncode(chatListMap);
    prefs.setString('chat_record_${userId}_$friendId', chatListString);
  }

  static Future<void> deleteChatMessage(String userId, String friendId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_record_${userId}_$friendId');
  }

  static Future<List<ChatMessage>> loadChatMessage(
      String userId, String friendId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String chatListString =
        prefs.getString('chat_record_${userId}_$friendId') ?? '';
    if (chatListString == '') {
      return [];
    }
    List<Map<String, dynamic>> chatListMap =
        List<Map<String, dynamic>>.from(jsonDecode(chatListString));
    List<ChatMessage> chatList = chatListMap
        .map((chatMap) => ChatMessage(
              username: chatMap['username'],
              message: chatMap['message'],
              avatar: chatMap['avatar'],
              userId: chatMap['userId'],
              recipient: chatMap['recipient'],
              isSender: chatMap['isSender'],
            ))
        .toList();
    return chatList;
  }

  Future<void> sendMessage(String toUserId) async {
    final url = Uri.parse('http://127.0.0.1:8080/v1/chats');
    final userinfo = UserService.userInfo;
    final response = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8',
      },
      body: jsonEncode({'user_id': userinfo['userId'], 'friend_id': toUserId}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      // 请求成功
    } else {
      // 请求失败
    }
  }

  Future<List<Message>> getChatList() async {
    final userinfo = UserService.userInfo;
    final url =
        Uri.parse('http://127.0.0.1:8080/v1/chats/${userinfo["userId"]}');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final chats = data['chats'] ?? [];
      final List<Message> messages =
          chats.map((e) => Message.fromJson(e)).cast<Message>().toList();
      return messages;
    } else {
      // 请求失败
      return [];
    }
  }
}
