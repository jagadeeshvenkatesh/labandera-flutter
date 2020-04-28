import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

import '../controller.dart';
import '../helper.dart';
import '../model.dart';

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
                            child: Text('Update Order'),
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
