import 'package:flutter/material.dart';
import 'chat_detail.dart';
import 'package:yichat/models/contacts.dart';
import 'package:yichat/services/chat.dart';

class ContactDetailsPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailsPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(contact.avatar),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.username, style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text(contact.email, style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ChatService().sendMessage(contact.userId);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(
                    contact: contact,
                  ),
                ),
              );
            },
            child: Text('发消息'),
          ),
        ],
      ),
    );
  }
}
