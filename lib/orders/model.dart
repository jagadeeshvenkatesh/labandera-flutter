class Order {
  final String id;
  final String name;
  final String status;
  final String price;
  final String isPaid;
  final String dateReceived;
  final String dateReturned;
  Order(
    {
      this.id,
      this.name,
      this.status,
      this.price,
      this.isPaid,
      this.dateReceived,
      this.dateReturned
    }
  );

  factory Order.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Order(
      id: json['_id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      price: json['price'] as String,
      isPaid: json['isPaid'] as String,
      dateReceived: json['dateReceived'] as String,
      dateReturned: json['dateReturned'] as String,
    );
  }
}
