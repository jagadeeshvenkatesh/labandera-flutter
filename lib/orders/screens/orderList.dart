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
        child: new Icon(Icons.add), // Add new order
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, "/logout", (_) => false);
        },
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(orders[index].status),
                child:getIcon(orders[index].status),
              ),
            title: Text(orders[index].name),
            subtitle: Text('Date Received: ' + orders[index].dateReceived),
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
            ),
          );          
        },
      ),
    );
  }

  Color getColor(String status) {
    switch (status) {
      case 'Queued':
        return Colors.amber;
        break;
      case 'Washing in progress':
        return Colors.cyan;
        break;
      case 'Ready for Pickup/Delivery':
        return Colors.blue;
        break;
      case 'Order Complete':
        return Colors.green;
        break;
      case 'Cancelled':
        return Colors.red;
        break;
      
      default:
        return Colors.green;
    }
  }
  
  Icon getIcon(String status) {
    switch (status) {
      case 'Queued':
        return new Icon(Icons.access_time);
        break;
      case 'Washing in progress':
        return new Icon(Icons.local_laundry_service);
        break;
      case 'Ready for Pickup/Delivery':
        return new Icon(Icons.shopping_basket);
        break;
      case 'Order Complete':
        return new Icon(Icons.check_circle_outline);
        break;
      case 'Cancelled':
        return new Icon(Icons.cancel);
        break;
      
      default:
        return new Icon(Icons.local_laundry_service);
    }
  }
}
