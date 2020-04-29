import 'package:Labandera/utils/auth.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

import '../controller.dart';
import '../helper.dart';
import '../model.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  OrderDetail(this.order);

  @override
  _OrderDetailState createState() => _OrderDetailState(order);
}

class _OrderDetailState extends State<OrderDetail> {
  Order order;
  _OrderDetailState(this.order);
  String _myActivity;
  String _myPayment;
  String _myActivityResult;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController dateReceivedController = TextEditingController();
  TextEditingController dateReturnedController = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  String token; 

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    token = jwt;
    setState(() => token = jwt);
    return jwt;
  }
  
  


  Future<Order> _updatedOrder;


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
    TextStyle textStyle = Theme.of(context).textTheme.title;
    TextStyle buttonStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    nameController.text = order.name;
    priceController.text = '₱ ' + order.price;
    statusController.text = order.status;
    paymentController.text = order.isPaid;
    dateReceivedController.text = convertDateFromString(order.dateReceived);
    
    if (order.dateReturned != '') {
      dateReturnedController.text = convertDateFromString(order.dateReturned);
    }

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
        title: Text('Order Details'),
        actions: <Widget>[
          // TODO Add menu later
          // PopupMenuButton<String>(
          //   onSelected: select,
          //   itemBuilder: (BuildContext context) {
          //     return choices.map((String choice){
          //       return PopupMenuItem<String>(
          //         value: choice,
          //         child: Text(choice),
          //       );
          //     }).toList();
          //   },
          // ),
        ],
      ),
      body: Padding( 
        padding: EdgeInsets.only(top:35.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  enabled: false,
                  controller: nameController,
                  style: textStyle,
                  onChanged: (value)=> order.name,
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:15.0, bottom: 15.0),
                  child: TextField(
                    enabled: false,
                    controller: dateReceivedController,
                    style: textStyle,
                    decoration: InputDecoration(
                      labelText:  'Date Received',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    ),
                  )
                ),
                if (order.dateReturned != '')
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    enabled: false,
                    controller: dateReturnedController,
                    style: textStyle,
                    decoration: InputDecoration(
                      labelText:  'Date Returned',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    enabled: false,
                    controller: priceController,
                    style: textStyle,
                    decoration: InputDecoration(
                      labelText:  'Price',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    enabled: false,
                    controller: paymentController,
                    style: textStyle,
                    decoration: InputDecoration(
                      labelText:  'Payment Status',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    enabled: false,
                    controller: statusController,
                    style: textStyle,
                    decoration: InputDecoration(
                      labelText:  'Status',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    ),
                  )
                ),
                if (
                  order.isPaid == 'NA' &&
                  order.status != 'Order Complete' &&
                  order.status != 'Washing in progress' &&
                  order.status != 'Cancelled'
                )
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.teal,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                    },
                    child: Text('Mark as Paid',
                      textAlign: TextAlign.center,
                      style: buttonStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                  ),
                ),
                if (
                  order.status == 'Queued'
                )
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.teal,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      // updateOrderStatus
                      print(order.status);
                      print(order.id);
                      print(token);
                    },
                    child: Text('Washing in progress',
                      textAlign: TextAlign.center,
                      style: buttonStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                  ),
                ),
                if (
                  order.status == 'Washing in progress'
                )
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.teal,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                          },
                    child: Text('Ready for Pickup/Delivery',
                      textAlign: TextAlign.center,
                      style: buttonStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                  ),
                ),
                if (
                  order.isPaid == 'Paid' &&
                  order.status != 'Order Complete' &&
                  order.status != 'Cancelled' &&
                  order.status == 'Ready for Pickup/Delivery'
                )
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.teal,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                          },
                    child: Text('Complete Order',
                      textAlign: TextAlign.center,
                      style: buttonStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                  ),
                ),
              ],
            )
          ],
        )
      )
    );
  }
}
