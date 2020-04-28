import 'package:flutter/material.dart';

import './screens/loginPage.dart';
import './screens/logoutPage.dart';
import './utils/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "auth");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Labandera Laundry Shop';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with 'flutter run'. You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // 'hot reload' (press 'r' in the console where you ran 'flutter run',
        // or simply save your changes to 'hot reload' in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
      ),
      home: LoginPage(title: appTitle),
      routes: {
        "/logout": (_) => new LogoutPage(),
      },
    );
  }
}
