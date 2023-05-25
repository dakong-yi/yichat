import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/services.dart';

import 'pages/chat.dart';
import 'pages/contacts.dart';
import 'pages/profile.dart';
import 'pages/search.dart';
import 'pages/navigation.dart';
import 'pages/login.dart';
import 'services/im_service.dart';

import 'services/user.dart';
import 'services/contacts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await UserService.getLoggedIn();
  if (isLoggedIn) {
    var im = IMService();
    await im.connect('127.0.0.1', 1234);
  }
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final brightness = MediaQuery.platformBrightnessOf(context);
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    final appBarColor =
        brightness == Brightness.dark ? Colors.grey[850] : Colors.white;
    final appBarTextColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;
    final darkTheme = ThemeData.dark().copyWith(
      // Define your dark mode colors and styles here
      primaryColor: Colors.blue[200],
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: appBarColor,
        foregroundColor: appBarTextColor,
        elevation: 0, // 隐藏下划线
      ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.green[200]),
    );
    return MaterialApp(
      title: 'Flutter Yichat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: appBarTextColor,
          elevation: 0, // 隐藏下划线
        ),
      ),
      darkTheme: darkTheme,
      home: isLoggedIn ? const MyHomePage() : const NavigationPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    print(UserService.userInfo);
    await ContactService().getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ChatPage(),
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
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '聊天'),
          BottomNavigationBarItem(
            icon: badges.Badge(
              badgeContent: Text(
                '3',
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(Icons.account_box),
            ),
            label: '通讯录',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: '我')
        ],
      ),
    );
  }
}
