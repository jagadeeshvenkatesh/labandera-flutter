import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:date_format/date_format.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

const String apiBase = 'https://api.labada.tigasoft.dev/api';

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

class Order {
  final int id;
  final String name;
  final String status;
  final String price;
  final String isPaid;
  final String dateReceived;
  final String dateReturned;
  Order(
      {this.id,
      this.name,
      this.status,
      this.price,
      this.isPaid,
      this.dateReceived,
      this.dateReturned});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      price: json['price'] as String,
      isPaid: json['isPaid'] as String,
      dateReceived: json['dateReceived'] as String,
      dateReturned: json['dateReturned'] as String,
    );
  }
}

class OrderScreenDropDown extends StatefulWidget {
  @override
  _OrderScreenDropDownState createState() => _OrderScreenDropDownState();
}

class _OrderScreenDropDownState extends State<OrderScreenDropDown> {
  String _myActivity;
  String _myPayment;
  String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  Future<Order> _futureOrder;

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivityResult = _myActivity + ' ' + _myPayment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context).settings.arguments;

    @override
    void initState() {
      super.initState();
      _myActivity = order.status;
      _myPayment = order.isPaid;
      _myActivityResult = '';
    }

    Widget dateReturned;

    if (order.dateReturned != '') {
      dateReturned = Text(
        convertDateFromString(order.dateReturned),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      );
    } else {
      dateReturned = Text(
        'Not yet returned',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Labada Info'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Container(
                            child: Text(
                              order.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            'Order',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Container(
                            child: Text(
                              '123',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            'Weight/ Items',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Container(
                            child: Text(
                              order.price,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            'Price',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              convertDateFromString(order.dateReceived),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            'Date laundry received from order',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Container(child: dateReturned),
                          Text(
                            'Date laundry returned to order',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: DropDownFormField(
                  titleText: 'Order status',
                  hintText: order.status,
                  value: _myActivity,
                  onSaved: (value) {
                    setState(() {
                      _myActivity = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _myActivity = value;
                    });
                  },
                  dataSource: [
                    {
                      "display": "Queued",
                      "value": "Queued",
                    },
                    {
                      "display": "Washing in progress",
                      "value": "Washing in progress",
                    },
                    {
                      "display": "Ready for Pickup/Delivery",
                      "value": "Ready for Pickup/Delivery",
                    },
                    {
                      "display": "Order Complete",
                      "value": "Order Complete",
                    },
                    {
                      "display": "Cancelled",
                      "value": "Cancelled",
                    },
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: DropDownFormField(
                  titleText: 'Payment status',
                  hintText: order.isPaid,
                  value: _myPayment,
                  onSaved: (value) {
                    setState(() {
                      _myPayment = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _myPayment = value;
                    });
                  },
                  dataSource: [
                    {
                      "display": "Pending",
                      "value": "Pending",
                    },
                    {
                      "display": "Paid",
                      "value": "Paid",
                    },
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: (_futureOrder == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Create Data'),
                            onPressed: () {
                              setState(() {
                                _futureOrder =
                                    updateOrder(_myActivity, _myPayment);
                              });
                            },
                          ),
                        ],
                      )
                    : FutureBuilder<Order>(
                        future: _futureOrder,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot);
                            return Text('TODO fix submit later');
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          return CircularProgressIndicator();
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

String convertDateFromString(String strDate) {
  DateTime todayDate = DateTime.parse(strDate);
  return formatDate(todayDate, [MM, ' ', dd, ', ', yyyy]);
}

class OrderList extends StatelessWidget {
  final List<Order> orders;

  OrderList({Key key, this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(orders[index].name),
            subtitle: Text('Status: ' + orders[index].status),
            // When a user taps the ListTile, navigate to the DetailScreen.
            // Notice that you're not only creating a DetailScreen, you're
            // also passing the current order through to it.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderScreenDropDown(),
                  // Pass the arguments as part of the RouteSettings. The
                  // DetailScreen reads the arguments from these settings.
                  settings: RouteSettings(
                    arguments: orders[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
