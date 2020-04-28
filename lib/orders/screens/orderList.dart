import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model.dart';
import './orderDetail.dart';

class OrderList extends StatelessWidget {
  final List<Order> orders;

  OrderList({Key key, this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Orders'),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.power_settings_new),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, "/logout", (_) => false);
        },
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
