import 'package:flutter/material.dart';
import 'package:yichat/services/contacts.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: '搜索账号',
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          onSubmitted: (value) {
            print(value);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultPage(query: value),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final query = _controller.text;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultPage(query: query),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(),
    );
  }
}

class SearchResultPage extends StatelessWidget {
  final String query;

  const SearchResultPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索结果'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: ContactService().search(query),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, String>>> snapshot) {
          if (snapshot.hasData && snapshot.data?.length != 0) {
            List<Map<String, String>>? _users = snapshot.data;
            return ListView.builder(
              itemCount: _users?.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://tupian.qqw21.com/article/UploadPic/2015-8/201582921171921923.jpg',
                    ),
                  ),
                  title: Text(_users![index]['username']!),
                  subtitle: Text(_users[index]['email']!),
                  trailing: TextButton(
                    onPressed: () {
                      ContactService()
                          .addUserToContacts(_users[index]['user_id']!);
                    },
                    child: Text('添加通讯录'),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('没有找到匹配的用户'),
              // child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
