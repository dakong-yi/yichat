import 'package:yichat/pages/friend_request.dart';
import 'package:flutter/material.dart';
import 'contact_detail.dart';

import 'package:yichat/models/contacts.dart';
import 'package:yichat/services/contacts.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Future<List<Contact>>? _contacts;
  @override
  void initState() {
    super.initState();
    _contacts = ContactService().getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: FutureBuilder<List<Contact>>(
        future: _contacts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FriendRequestPage(),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Add new contact'),
                      leading: CircleAvatar(
                        child: Icon(Icons.add),
                      ),
                    ),
                  );
                }
                final contact = contacts[index - 1];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ContactDetailsPage(contact: contact),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(contact.username),
                    subtitle: Text(contact.email),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(contact.avatar),
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
