import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Customer>> fetchCustomers(http.Client client) async {
  final response =
  await client.get('https://my-json-server.typicode.com/sudoist/labandera-my-json/customer');

  // Use the compute function to run parseCustomers in a separate isolate.
  return compute(parseCustomers, response.body);
}

// A function that converts a response body into a List<Customer>.
List<Customer> parseCustomers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
}

class Customer {
  final int id;
  final String name;
  final String status;
  Customer({this.id, this.name, this.status});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Labandera Laundry App';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Customer>>(
        future: fetchCustomers(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? CustomersList(customers: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class CustomersList extends StatelessWidget {
  final List<Customer> customers;

  CustomersList({Key key, this.customers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(25.0),
      itemCount: customers.length,
      itemBuilder: (context, int index) {

        if (index == 0) {
          // return the header
          return new Row(
              children: <Widget>[
                new Expanded(
                    child: new Text(
                      'Customer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    )
                ),
                new Expanded(
                    child: new Text(
                      'Status',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    )
                ),
              ]
          );
        }
        index -= 1;
        return new Container(
          //TODO Add row coloring - color: Colors.red,
          child: Row(
            children: <Widget>[
              new Expanded(child: new Text(customers[index].name)),
              new Expanded(child: new Text(customers[index].status)),
            ],

          )
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
