import 'package:flutter/material.dart';
import 'package:yichat/services/user.dart';
import '../services/im_service.dart';
import 'dart:convert';
import 'package:yichat/models/contacts.dart';
import 'package:yichat/models/message.dart';
import 'package:yichat/services/chat.dart';

class ChatDetailPage extends StatefulWidget {
  final Contact contact;

  const ChatDetailPage({Key? key, required this.contact}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Contact contact = widget.contact;
    IMService().onMessageReceived = (message) {
      print(message);
      Map<String, dynamic> myMap = jsonDecode(message);
      ChatMessage newMessage = ChatMessage(
          userId: myMap["Sender"],
          avatar: contact.avatar,
          username: contact.username,
          message: myMap["Content"],
          recipient: myMap["Recipient"],
          isSender: false);
      setState(() {
        _messages.add(newMessage);
        ChatService.saveChatMessage(
            UserService.userInfo['userId'], contact.userId, _messages);
      });
      _maxScorllExtent();
    };
    loadChatMessages();
  }

  void _maxScorllExtent() {
    Future.delayed(Duration(milliseconds: 50), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void loadChatMessages() async {
    Contact contact = widget.contact;
    var userinfo = UserService.userInfo;
    _messages =
        await ChatService.loadChatMessage(userinfo['userId'], contact.userId);
    Future.delayed(Duration(milliseconds: 30), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    Contact contact = widget.contact;
    var userinfo = UserService.userInfo;
    setState(() {
      _messages.add(ChatMessage(
          userId: userinfo['userId'],
          avatar: userinfo['avatar'],
          username: userinfo['username'],
          message: text,
          recipient: contact.userId,
          isSender: true));
    });
    var im = IMService();
    im.SendMsg(contact.userId, text);
    _maxScorllExtent();
  }

  Widget _buildMessage(ChatMessage message) {
    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message.isSender) ...[
          CircleAvatar(
            backgroundImage: NetworkImage(message.avatar),
          ),
          SizedBox(width: 8),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: message.isSender ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft:
                  message.isSender ? Radius.circular(16) : Radius.circular(0),
              bottomRight:
                  message.isSender ? Radius.circular(0) : Radius.circular(16),
            ),
          ),
          child: Text(
            message.message,
            style: TextStyle(
              color: message.isSender ? Colors.white : Colors.black,
            ),
          ),
        ),
        if (message.isSender) ...[
          SizedBox(width: 8),
          CircleAvatar(
            backgroundImage: NetworkImage(message.avatar),
          ),
        ],
      ],
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        // padding: const EdgeInsets.only(bottom: 20.0), // 添加这一行
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Contact contact = widget.contact;
    FocusScope.of(context).requestFocus(_focusNode);
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.username),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return _buildMessage(message);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
