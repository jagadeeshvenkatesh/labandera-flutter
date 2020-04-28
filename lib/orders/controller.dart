import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import './model.dart';

/*
 * Get order list
 */
Future<List<Order>> fetchOrders(http.Client client, String token) async {
  final response = await client.get(
    '$apiBase/orders',
    headers: {'x-access-token': token},
  );

  // Use the compute function to run parseOrders in a separate isolate.
  return compute(parseOrders, response.body);
}

// A function that converts a response body into a List<Order>.
List<Order> parseOrders(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Order>((json) => Order.fromJson(json)).toList();
}

/*
 * Get single order
 */
Future<Order> fetchOrder(String id) async {
  final response = await http.get('$apiBase/order/$id');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Order.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load order');
  }
}

/*
 * Update order
 */
Future<Order> updateOrder(String status, String isPaid) async {
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/orders',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'status': status,
      'isPaid': isPaid,
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response, then parse the JSON.
    return Order.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response, then throw an exception.
    throw Exception('Failed to load order');
  }
}


