import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:yichat/models/friend_request.dart';
import 'package:yichat/services/contacts.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FriendRequestPageState createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  Future<List<FriendRequest>>? _futureFriendRequests;

  @override
  void initState() {
    super.initState();
    _futureFriendRequests = ContactService().getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('new friend'),
      ),
      body: FutureBuilder<List<FriendRequest>>(
        future: _futureFriendRequests,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final friendRequests = snapshot.data!;
            return ListView.builder(
              itemCount: friendRequests.length,
              itemBuilder: (context, index) {
                final friendRequest = friendRequests[index];
                return ListTile(
                  title: Text(friendRequest.username),
                  subtitle: Text(friendRequest.email),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friendRequest.avatar),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      if (friendRequest.status == 0) {
                        var isOk = await ContactService()
                            .acceptFriendRequest(friendRequest.id);
                        if (isOk) {
                          setState(() {
                            friendRequest.status = 1;
                          });
                        }
                      }
                    },
                    child: Text(
                      friendRequest.status == 0
                          ? '接受'
                          : friendRequest.status == 1
                              ? '已接受'
                              : friendRequest.status == 2
                                  ? '已拒绝'
                                  : friendRequest.status == 11
                                      ? '已过期'
                                      : '已过期',
                    ), // 根据状态显示不同文案
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
