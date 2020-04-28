import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/order.dart';

class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);
  
  factory HomePage.fromBase64(String jwt) =>
    HomePage(
      jwt,
      json.decode(jwt)
    );

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      // appBar: AppBar(title: Text(payload['token'])),
      body: FutureBuilder<List<Order>>(
        future: fetchOrders(http.Client(), payload['token']),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? OrderList(orders: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
}
