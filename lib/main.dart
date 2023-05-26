import 'package:flutter/material.dart';

import 'pages/app.dart';
import 'services/im_service.dart';
import 'services/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await UserService.getLoggedIn();
  if (isLoggedIn) {
    var im = IMService();
    await im.connect('127.0.0.1', 1234);
  }
  runApp(MyApp(isLoggedIn: isLoggedIn));
}
