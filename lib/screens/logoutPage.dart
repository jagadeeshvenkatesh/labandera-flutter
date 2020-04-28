import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Logout Page"),
      ),
      body: new Center(
        child: new Text('You have been logged out'),
      ),
    );
  }
}