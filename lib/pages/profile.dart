import 'package:yichat/services/user.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = UserService.userInfo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user['avatar']),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['username'], style: TextStyle(fontSize: 18)),
                        Text(user['email'],
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              const ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  UserService.clearUserInfo();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 30,
//                   backgroundImage: NetworkImage(
//                       'https://mmbiz.qpic.cn/mmbiz_jpg/SrHhzvpFohLFicYvBORoUwYgrojp5OZOZU6uVNzE0cGTCY5r5OBmo9kfPA0DYAuDq5KCwEOpDdRgVQ8Q2pDdOGw/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1'),
//                 ),
//                 const SizedBox(width: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text('John Doe', style: TextStyle(fontSize: 18)),
//                     Text('@johndoe',
//                         style: TextStyle(fontSize: 14, color: Colors.grey)),
//                     Text('Account Number: 119110120',
//                         style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text('Profile'),
//             trailing: Icon(Icons.arrow_forward_ios),
//           ),
//           ListTile(
//             leading: Icon(Icons.settings),
//             title: Text('Settings'),
//             trailing: Icon(Icons.arrow_forward_ios),
//           ),
//           ListTile(
//             leading: Icon(Icons.help),
//             title: Text('Help'),
//             trailing: Icon(Icons.arrow_forward_ios),
//           ),
//         ],
//       ),
//     );
//   }
// }
