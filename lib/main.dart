import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:http/http.dart' as http;

Future<Customer> updateCustomer(String status, String isPaid) async {
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/albums',
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
    return Customer.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response, then throw an exception.
    throw Exception('Failed to load customer');
  }
}

String convertDateFromString(String strDate){
  DateTime todayDate = DateTime.parse(strDate);
  return formatDate(todayDate, [MM, ' ', dd, ', ', yyyy]);
}

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
  final String price;
  final String isPaid;
  final String dateReceived;
  final String dateReturned;
  Customer({this.id, this.name, this.status, this.price, this.isPaid, this.dateReceived, this.dateReturned});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Labandera Laundry App';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: Colors.teal,
      ),
      home: TestPage(),
//      home: MyHomePage(title: appTitle),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(customers[index].name),
            subtitle: Text('Status: ' + customers[index].status),
            // When a user taps the ListTile, navigate to the DetailScreen.
            // Notice that you're not only creating a DetailScreen, you're
            // also passing the current customer through to it.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerScreenDropDown(),
                  // Pass the arguments as part of the RouteSettings. The
                  // DetailScreen reads the arguments from these settings.
                  settings: RouteSettings(
                    arguments: customers[index],
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

class CustomerScreenDropDown extends StatefulWidget {
  @override
  _CustomerScreenDropDownState createState() => _CustomerScreenDropDownState();
}

class _CustomerScreenDropDownState extends State<CustomerScreenDropDown> {
  String _myActivity;
  String _myPayment;
  String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  Future<Customer> _futureCustomer;

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
    final Customer customer = ModalRoute.of(context).settings.arguments;

    @override
    void initState() {
      super.initState();
      _myActivity = customer.status;
      _myPayment = customer.isPaid;
      _myActivityResult = '';
    }

    Widget dateReturned;

    if (customer.dateReturned != '') {
      dateReturned = Text(
        convertDateFromString(customer.dateReturned),
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
                              customer.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            'Customer',
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
                              customer.price,
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
                              convertDateFromString(customer.dateReceived),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            'Date laundry received from customer',
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
                              child: dateReturned
                          ),
                          Text(
                            'Date laundry returned to customer',
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
                  hintText: customer.status,
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
                  hintText: customer.isPaid,
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
                child: (_futureCustomer == null)
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Create Data'),
                      onPressed: () {
                        setState(() {
                          _futureCustomer = updateCustomer(_myActivity, _myPayment);
                        });
                      },
                    ),
                  ],
                )
                    : FutureBuilder<Customer>(
                  future: _futureCustomer,
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

class TestPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TestPage> {
  String barcode = '';
  Uint8List bytes = Uint8List(200);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Labada Scan Order QR'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 200,
                child: Image.memory(bytes),
              ),
              RaisedButton(onPressed: _scan, child: Text("Scan QR")),
            ],
          ),
        ),
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
  }
}
