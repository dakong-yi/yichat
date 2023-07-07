import 'package:flutter/material.dart';
// import 'package:badges/badges.dart' as badges;

import 'contacts.dart';
import 'profile.dart';
import 'search.dart';
import 'package:intl/intl.dart';
import 'package:yichat/services/chat.dart';

import 'chat_detail.dart';
import 'add_friend.dart';
import 'package:yichat/models/chat.dart';
import 'package:yichat/services/user.dart';
import 'package:yichat/models/contacts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final chatPageKey = GlobalKey<_ChatPageState>();
  void refreshPage(int index) {
    if (index == 0) {
      // Refresh ChatPage
      chatPageKey.currentState!.refreshMessages();
    } else if (index == 1) {
      // Refresh ContactsPage
    } else if (index == 2) {
      // Refresh SearchPage
    } else if (index == 3) {
      // Refresh ProfilePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ChatPage(
            key: chatPageKey,
          ),
          ContactsPage(),
          SearchPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.red, // Change this to the color you want
        unselectedItemColor: Colors.grey, // Change this to the color you want
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          refreshPage(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '聊天'),
          // BottomNavigationBarItem(
          //   icon: badges.Badge(
          //     badgeContent: Text(
          //       '3',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     child: Icon(Icons.account_box),
          //   ),
          //   label: '通讯录',
          // ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: '我')
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<List<Message>>? _messages;

  void refreshMessages() {
    setState(() {
      print("refresh");
      _messages = ChatService().getChatList();
      // Add code to refresh messages variable
    });
  }

  @override
  void initState() {
    super.initState();
    _messages = ChatService().getChatList();
    print(1234);
  }

  void _showMenu(BuildContext context) async {
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 115, 0, 0),
      items: [
        PopupMenuItem(
          child: Text('发起群聊'),
          value: 'group_chat',
        ),
        PopupMenuItem(
          child: Text('添加好友'),
          value: 'add_friend',
        ),
        PopupMenuItem(
          child: Text('扫一扫'),
          value: 'scan',
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey),
      ),
      // color: Colors.white,
      elevation: 8,
    );

    if (result == 'group_chat') {
      // 处理发起群聊的逻辑
    } else if (result == 'add_friend') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddFriendPage()),
      );
    } else if (result == 'scan') {
      // 处理扫一扫的逻辑
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showMenu(context)),
          ],
        ),
        body: FutureBuilder<List<Message>>(
          future: _messages,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final msgs = snapshot.data!;
              return ListView.builder(
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  final message = msgs[index];
                  return Dismissible(
                    key: Key(message.userId),
                    onDismissed: (direction) {
                      setState(() {
                        msgs.removeAt(index);
                      });
                      final userinfo = UserService.userInfo;
                      ChatService.deleteChatMessage(
                          userinfo['userId'], message.userId);
                    },
                    background: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailPage(
                                contact: Contact(
                                    userId: message.userId,
                                    username: cachedContacts[message.userId]!
                                        .username,
                                    email:
                                        cachedContacts[message.userId]!.email,
                                    avatar: cachedContacts[message.userId]!
                                        .avatar)),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              cachedContacts[message.userId]!.avatar),
                        ),
                        title: Text(cachedContacts[message.userId]!.username),
                        subtitle: Text(message.lastMessage),
                        trailing:
                            Text(DateFormat('HH:mm').format(message.timestamp)),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
