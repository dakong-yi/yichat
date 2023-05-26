import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';
import 'navigation.dart';
import 'login.dart';

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
