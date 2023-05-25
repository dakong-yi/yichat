import 'dart:convert';
import 'package:http/http.dart';

import 'package:yichat/models/contacts.dart';
import 'package:yichat/models/friend_request.dart';
import 'user.dart';

class ContactService {
  Future<List<Contact>> getContacts() async {
    final userinfo = UserService.userInfo;
    final response = await get(
        Uri.parse('http://127.0.0.1:8080/v1/friends/${userinfo['userId']}'));
    if (response.statusCode == 200) {
      // 如果请求成功，解析响应体并返回好友请求列表
      final List<dynamic> data = jsonDecode(response.body)['friends'];
      List<Contact> contacts =
          data.map((json) => Contact.fromJson(json)).toList();
      for (var element in contacts) {
        cachedContacts[element.userId] = element;
      }
      return contacts;
    } else {
      // 如果请求失败，抛出异常
      throw Exception('Failed to fetch friend requests');
    }
  }

  Future<List<FriendRequest>> getFriendRequests() async {
    final userinfo = UserService.userInfo;
    final response = await get(Uri.parse(
        'http://127.0.0.1:8080/v1/friends/requests/${userinfo['userId']}'));
    if (response.statusCode == 200) {
      // 如果请求成功，解析响应体并返回好友请求列表
      final List<dynamic> data = jsonDecode(response.body)['friends'];
      return data.map((json) => FriendRequest.fromJson(json)).toList();
    } else {
      // 如果请求失败，抛出异常
      throw Exception('Failed to fetch friend requests');
    }
  }

  Future<bool> acceptFriendRequest(String id) async {
    final userinfo = UserService.userInfo;
    final response = await post(
      Uri.parse(
          'http://127.0.0.1:8080/v1/friends/${userinfo['userId']}/$id/accept'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': userinfo['userId'],
        'friend_id': id,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      throw Exception('Failed to update friend request status');
    }
  }

  Future<List<Map<String, String>>> search(String query) async {
    final response =
        await get(Uri.parse('http://127.0.0.1:8080/v1/users/$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, String>> myMapList = [];
      Map<String, String> myMap = {
        'username': data['user']['username'],
        'email': data['user']['email'],
        'user_id': data['user']['id'].toString(),
      };
      myMapList.add(myMap);
      return myMapList;
    } else {
      return [];
      throw Exception('搜索出错了：${response.statusCode}');
    }
  }

  Future<bool> addUserToContacts(
    String userId,
  ) async {
    final userinfo = await UserService.getUserInfo();
    final response = await post(
      Uri.parse('http://127.0.0.1:8080/v1/friends'),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8',
      },
      body: jsonEncode({'user_id': userinfo['userId'], 'friend_id': userId}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
